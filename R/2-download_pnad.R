download_data <- function(){
  
ftp_ibge_pnadc <- "ftp.ibge.gov.br/Trabalho_e_Rendimento/Pesquisa_Nacional_por_Amostra_de_Domicilios_continua/Trimestral/Microdados/"

check <- TRUE

year <- 2012

files <- c()

while(isTRUE(check)){
  
  url <- paste0(ftp_ibge_pnadc, year, "/")
  
  check <- RCurl::url.exists(url)
  
  if(isTRUE(check)){
    
    ftp_files <- RCurl::getURLContent(url) |>
      strsplit("\r*\n") |>
      unlist() 
    
    zip_files <- gsub(".*\\s(\\S+\\.zip)$", "\\1", ftp_files)
    
    zip_files <- paste0(year, "/", zip_files)
    
    files <- c(files, zip_files)
    
  }
  
  year <- year + 1 
  
}

db_files <- data.frame(files)
db_files$link <- paste0(ftp_ibge_pnadc, db_files$files)
db_files$dest <- paste0("data/zip/", gsub("^.{5}", "", db_files$files))
db_files$final <- paste0("data/txt/PNADC_", substring(db_files$files, 12,13),substring(db_files$files, 1,4),".txt")

ls_parquet <- fs::dir_ls("data/parquet/") 
ls_txt <-  gsub("parquet","txt", ls_parquet)

txt_to_download <- db_files$final[!db_files$final %in% ls_txt]

db_queue <- db_files[db_files$final %in% txt_to_download,]

if(length(db_queue$link) > 0) download <- curl::multi_download(urls = db_queue$link, destfiles = db_queue$dest)

download$dest <- db_queue$dest 

result <- unname(unlist(download[download$success == TRUE,"dest"]))

return(result)

}