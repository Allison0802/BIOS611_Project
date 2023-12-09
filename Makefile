PHONY: clean

clean:
	rm derived_data/*
	rm figures/*

data/cleaned_data.csv: data_cleaning.R

figures/intake_reasons.png:data/cleaned_data.csv Exploratory/reasons.R
	Rscript Exploratory/reasons.R
	
figures/intake_species.png:data/cleaned_data.csv Exploratory/species.R
	Rscript Exploratory/speciess.R