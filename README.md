# Tidy My VCF!
A simple R script leveraging tidyR to reformat a VCF with "tidy" data principles. The script saves the tidied VCF in zstd-compressed Apache Arrow format so that it can be efficiently evaluated elsewhere, e.g., with the Polars DataFrame engine.

To run, simply modify `config.R` with the file paths, output file names, etc., and then run:
```
Rscript tidy_vcf.R
```

For more on what "tidy" data principles are, see the following:
 - [The Tidy Data Chapter in Hadley Wickham's *R for Data Science*](https://r4ds.had.co.nz/tidy-data.html)
 - [The CRAN Page about Tidy Data](https://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html#:~:text=Tidy%20data%20is%20a%20standard,Every%20column%20is%20a%20variable.)
 - [Hadley Wickham's original publication *Tidy Date*](https://vita.had.co.nz/papers/tidy-data.html)
