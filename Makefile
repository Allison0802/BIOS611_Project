PHONY: clean

clean:
	rm derived_data/*
	rm figures/*

data/cleaned_data.csv: data_cleaning.R

derived_data/derived_data.csv: exploratory.R data/cleaned_data.csv
	Rscript data_cleaning.R

figures/top5_reasons.png: derived_data/derived_data.csv exploratory_analysis/top5_reasons.R
	Rscript exploratory_analysis/top5_reasons.R
	
figures/top5_species.png: derived_data/derived_data.csv exploratory_analysis/top5_species.R
	Rscript exploratory_analysis/top5_species.R