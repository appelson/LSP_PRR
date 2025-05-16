library(digest)
library(pdftools)
library(png)
library(tidyverse)
library(tesseract)

files <- list.files("Misconduct 3", pattern = "\\.pdf$", full.names = TRUE)

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

hashes <- lapply(files, function(file) hash_pdf_pixels(file))

hashed_files <- hashes %>%
  bind_rows()

file <- "Misconduct 3/Final_letter__4.pdf"
ocr(file)
