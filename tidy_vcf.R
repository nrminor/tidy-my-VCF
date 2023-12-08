#!/usr/bin/env Rscript

# Load the renv environment
stopifnot("renv" %in% rownames(installed.packages()))
if ("renv" %in% rownames(installed.packages())) {
  renv::activate()
  renv::restore()
}

# load libraries
suppressPackageStartupMessages(c(
  library(devtools),
  library(dplyr),
  library(tidyr),
  library(stringr),
  library(readr),
  library(assertr),
  library(arrow),
  library(vcfR),
  library(renv)
))

# renv::snapshot()

# load configurations
source("./config.R")

# compile optional filtering function
optional_filtering <- compiler::cmpfun(
  function(desired_chrom, min_pos, max_pos, filtered_name, vcf){
    
    vcf %>%
      filter("CHROM" == desired_chrom) %>%
      filter(POS <= max_pos) %>%
      filter(POS >= min_pos) %>%
      arrow_table() %>%
      write_ipc_file(
        paste(filtered_name, ".tidy.variants.arrow", sep = ""),
        compression = "zstd"
      )
  }
)

# compile main function
main <- compiler::cmpfun(function(){
  
  # make sure provided VCF path actually exists
  stopifnot(stopifnot(file.exists(vcf_path)))
  
  # get the file basename
  vcf_name <- vcf_path %>%
    basename %>%
    str_remove(".vcf") %>%
    str_remove(".gz")
  
  # load and tidy the VCF
  tidy_vcf <- read.vcfR(vcf_path) %>%
    vcfR2tidy(., single_frame = TRUE)
  
  # write the metadata to a TSV
  tidy_vcf$meta %>%
    write_tsv(
      paste(vcf_name, ".metadata.tsv", sep = ""),
      na = "", quote = NULL
    )
  
  # run optional filtering
  if (whether_to_filter) {
    optional_filtering(
      desired_chrom, min_pos, max_pos, filtered_name, tidy_vcf$dat
    )
  }
  
  if (whether_to_write_arrow == TRUE){
    
    # write the genotypes to an arrow IPC format
    tidy_vcf$dat %>%
      arrow_table() %>%
      write_ipc_file(
        paste(vcf_name, ".tidy.variants.arrow", sep = ""),
        compression = "zstd"
      )
  
  } else {
    
    tidy_vcf$dat %>%
      write_tsv(paste(vcf_name, ".tidy.variants.tsv", sep = ""), delim = "\t")
    
  }
  
})
main()
