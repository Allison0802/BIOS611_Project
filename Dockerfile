FROM rocker/verse 

# Accept build argument for USER_ID with a default value
ARG USER_ID=1000

# Conditional logic to update UID and home directory ownership if USER_ID is different from current rstudio UID
RUN current_uid=$(id -u rstudio) && \
    if [ "$USER_ID" != "$current_uid" ]; then \
        usermod -u $USER_ID rstudio && \
        chown -R rstudio:rstudio /home/rstudio; \
    fi

RUN apt update && apt install -y man-db && rm -rf /var/lib/apt/lists/*
RUN yes|unminimize

RUN R -e "install.packages(\"tidyverse\")"
RUN R -e "install.packages(\"gbm\")"
RUN R -e "install.packages(\"plotmo\")"
