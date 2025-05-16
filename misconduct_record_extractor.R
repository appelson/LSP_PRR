# Loading Libraries
library(digest)
library(pdftools)
library(png)
library(tidyverse)
library(tesseract)

# Defining
files <- list.files("misconduct_records", pattern = "\\.pdf$", full.names = TRUE)

# Defining a function to create a unique hash for each file
hash_pdf_pixels <- function(file) {
  pdf_image <- pdf_render_page(file, page = 1, dpi = 300)
  temp_file <- tempfile(fileext = ".png")
  writePNG(pdf_image, temp_file)
  png_data <- readBin(temp_file, "raw", file.info(temp_file)$size)
  hash <- digest(png_data, algo = "sha256")
  data.frame(
    "hash" = hash,
    "file" = file
  )
}

# Getting a list of hash mini-dataframes
hashes <- lapply(files, function(file) hash_pdf_pixels(file))

# Getting a full dataframe
hashed_files <- hashes %>%
  bind_rows()