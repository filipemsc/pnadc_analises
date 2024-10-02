convert_to_parquet <- function(files, vars = NULL){
  
  txt_files <- files
  
  vars <- vars
  
  if(length(txt_files)>0){
  
    suppressWarnings({
    input <- base::readLines("input/input_PNADC_trimestral.txt",encoding="latin1")
    input <- input[13:length(input)-2]
    input <- gsub("\\*", ";", input)
    input <- gsub("(/;|;/)", '"', input)
    
    tmp <- tempfile()
    writeLines(input, tmp)
    
    input <- read.delim(tmp, header=FALSE,quote = '"',sep ="",col.names = c("start","col_name","length","label")) 
    input$start <- as.numeric(gsub("@","0", input$start))
    input$length <- as.numeric(gsub("[$|\\.]", "",input$length))
    input$end <- input$start + input$length - 1
    })
    
    for(txt in txt_files){
    
    parquet_file <- gsub("txt", "parquet", txt) 
    
    if(is.null(vars)){
    data_pnadc <- readr::read_fwf(txt,
                             col_positions = readr::fwf_widths(widths = input$length, col_names = input$col_name),
                             col_types = readr::cols(.default = "c"))
    
    data_pnadc$ID_DOMICILIO <- paste0(data_pnadc$UPA, data_pnadc$V1008, data_pnadc$V1014)
    
    }
    
    if(!is.null(vars)){
      
      data_pnadc <- readr::read_fwf(txt,
                                    col_positions = readr::fwf_widths(widths = input$length, col_names = input$col_name),
                                    col_types = readr::cols(.default = "c"),
                                    col_select = vars)
      
    }
    
    arrow::write_parquet(data_pnadc, parquet_file)
    
    rm(data_pnadc)
    
    }
    
  }
}