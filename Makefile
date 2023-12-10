PHONY: clean

clean:
	rm derived_data/*
	rm figures/*

data/cleaned_data.csv: data_cleaning.R

figures/intake_reasons.png: data/cleaned_data.csv Exploratory/reasons.R
	Rscript Exploratory/reasons.R
	
figures/intake_species.png: data/cleaned_data.csv Exploratory/species.R
	Rscript Exploratory/species.R
	
figures/intake_years.png: data/cleaned_data.csv Exploratory/time.R
	Rscript Exploratory/time.R
	
figures/residual_plot.png: data/cleaned_data.csv Regression/adoption.R
	Rscript Regression/adoption.R