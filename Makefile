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
	Rscript Regression/adoption.R
	
data/glm_estimate.csv: data/cleaned_data.csv Regression/adoption.R
	Rscript Regression/adoption.R
	
figures/estimate_species.png: data/glm_estimate.csv Regression/glm_estimates.R
	Rscript Regression/glm_estimates.R
	
figures/estimate_reasons.png: data/glm_estimate.csv Regression/glm_estimates.R
	Rscript Regression/glm_estimates.R