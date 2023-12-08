vcf_path <- "path/to/my/variants.vcf.gz"
desired_chrom <- "13"
min_pos <- 19092978
max_pos <- 19100027
filtered_name <- "cd8a_only"
whether_to_filter <- FALSE

# If your VCF file is very large, it is recommended to set this to TRUE so that
# it writes out in a compressed, memory efficient format
whether_to_write_arrow <- TRUE

