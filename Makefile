PHONY: clean

clean:
	rm data/*
	rm figures/*

data/cleaned_data.csv: Animal_Shelter_Animals.csv data_cleaning.R
	Rscript data_cleaning.R

figures/intake_reasons.png: data/cleaned_data.csv Exploratory/reasons.R
	Rscript Exploratory/reasons.R
	
figures/intake_species.png: data/cleaned_data.csv Exploratory/species.R
	Rscript Exploratory/species.R
	
figures/intake_years.png: data/cleaned_data.csv Exploratory/time.R
	Rscript Exploratory/time.R
	
figures/residual_plot.png: data/cleaned_data.csv Regression/adoption.R
	Rscript Regression/adoption.R
	
data/model_data.csv: data/cleaned_data.csv Regression/adoption.R
	Rscript Regression/adoption.R
	
figures/model_compare.png: data/model_data.csv Regression/performance.R
	Rscript Regression/performance.R
	
data/glm_estimate.csv: data/cleaned_data.csv Regression/adoption.R
	Rscript Regression/adoption.R
	
figures/estimate_species.png: data/glm_estimate.csv Regression/glm_estimates.R
	Rscript Regression/glm_estimates.R
	
figures/estimate_reasons.png: data/glm_estimate.csv Regression/glm_estimates.R
	Rscript Regression/glm_estimates.R

Report.html: Report.Rmd\
							data/model_data.csv\
							figures/intake_years.png\
							figures/intake_reasons.png\
							figures/intake_species.png\
							figures/residual_plot.png\
							figures/model_compare.png\
							figures/estimate_species.png\
							figures/estimate_reasons.png
	Rscript -e "rmarkdown::render('Report.Rmd',output_format='html_document')"