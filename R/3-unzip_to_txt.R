unzip_txt <- function(files){
  
  files_to_unzip <- files
  
  purrr::walk(files_to_unzip, function(x){ 
    unzip(x, exdir = "data/txt/",overwrite = TRUE)
    fs::file_delete(x)
  })
  
}
