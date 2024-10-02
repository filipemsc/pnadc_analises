# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
# library(tarchetypes) # Load other packages as needed.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  tar_target(
    name = download,
    command = download_data(),
    cue = tar_cue(mode="always")
  ),
  tar_files(
    name = path_zip,
    command = {
      download
      fs::dir_ls("data/zip")
  }
  ),
  tar_target(
    name = unzip_to_txt,
    command = {
      unzip_txt(path_zip)
    }
  ),
  tar_files(
    name = path_txt,
    command = {
      unzip_to_txt
      fs::dir_ls("data/txt")
    }
  ),
  tar_target(
    name = convert_parquet,
    command = {
      convert_to_parquet(path_txt) 
    }
  )
)

