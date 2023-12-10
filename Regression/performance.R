library(tidyverse)
library(gbm)
data <- read_csv(("data/model_data.csv"))

# compare performance of glm and gbm 

k_folds <- function(k, data, trainf, statf){
  n <- nrow(data);
  fold_id <- sample(1:k, n, replace=TRUE);
  do.call(rbind, Map(function(fold){
    train <- data %>% filter(fold != fold_id);
    test <- data %>% filter(fold == fold_id);
    model <- trainf(train);
    stat <- statf(model, test);
    tibble(fold=fold, stat=stat);
  },1:k));
}

n_folds <- 50;

form <- adopt ~ sexname + age_month + intakereason_new + speciesname_new

res.glm <- k_folds(n_folds, data,
                   function(data){
                     glm(form, data, family="binomial");
                   },
                   function(model, data){
                     p <- predict(model, data, type="response");
                     sum((p>0.5) == data$adopt, na.rm = T)/nrow(data);
                   }) %>% mutate(model="glm");


res.gbm <- k_folds(n_folds, data,
                   function(data){
                     gbm(adopt ~ sexname + age_month + intakereason_new + speciesname_new,
                         data = data,
                         distribution="bernoulli",
                         n.trees = 100,
                         interaction.depth = 2);
                   },
                   function(model, data){
                     p <- predict(model, data, type="response", n.trees = 100);
                     sum((p>0.5) == data$adopt, na.rm = T)/nrow(data);
                   }) %>% mutate(model="gbm");

res <- rbind(res.gbm, res.glm)
plot <- ggplot(res, aes(stat)) +
  geom_density(
    aes(
      fill= factor(model),
      x = stat
    ), linewidth = 0.5, alpha = 0.3
  ) +
  labs(title = "Model Performance", x = "% of correct predictions", y = "Density", fill = "Model") 

ggsave("figures/model_compare.png", plot, width=20, height=15, units='cm')

  
  