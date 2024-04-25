# Author: Alex Dunahoo
# Date: April 25, 2024
# Purpose: The str_to_scientific function will convert a string with any capitalization format to the standard "Genus species subspecies" format. This function was written to be used with the "mutate" function in dplyr.
# Dependecies: stringr

## Installs and loads required "stringr" package. 
if (!require("stringr")) {  install.packages("stringr", dependencies = TRUE) ; library(stringr)}

## Defines str_to_scientific function with "string" argument. 
str_to_scientific <- function(string) {
  
  ## Splits words into seperate objects.
  words <- unlist(str_split(string, " "))
  
  ## If the string has an incorrect number of words, the function will throw an error. 
  if (!(length(words) %in% c(2,3))) {
    stop("Incorrect word count in input string. Please provide only Genus and Species, or Genus, Species, and Subspecies.")
  }
  
  ## Changes the capitilization for each  word. 
  words[1] <- str_to_title(words[1])
  words[2] <- str_to_lower(words[2])
  ## Third word is optional as most strings will only have Genus and Species. 
  if (length(words) == 3) {
    words[3] <- str_to_lower(words[3])
  }
  
  ## Concatanate reformatted words back together. 
  scientific_name <- paste(words, collapse = " ")
  
  ## Return the reformatted string. 
  return(scientific_name)
}
