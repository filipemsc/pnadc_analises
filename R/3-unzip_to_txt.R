unzip_txt <- function(files){
  
  files_to_unzip <- files
  
  purrr::map_chr(files_to_unzip, function(x){ 
    result <- unzip(x, exdir = "data/txt/",overwrite = TRUE)
    fs::file_delete(x)
    return(result)
  })
  
}

fs::dir_ls("data/zip")

x <-unzip("data/zip/PNADC_012012_20220916.zip",exdir="data/txt", overwrite=TRUE)

x
