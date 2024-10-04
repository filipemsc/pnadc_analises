library(targets)
library(tarchetypes)

tar_source()

list(
  tar_target(
    name = zip_files,
    command = download_data(),
    cue = tar_cue(mode="always")
  ),

  tar_target(
    name = txt_files,
    command = unzip_txt(zip_files)
  ),
  tar_target(
    name = convert_parquet,
    command = convert_to_parquet(txt_files) 
  )
)

