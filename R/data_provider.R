#' Get the Data
#'
#' @description This function loads the dataset used in this package.
#'
#' @returns A data frame: the dataset used in this package.
#' @export
#'
#' @examples
#' get_data()
get_data <- function(){
  return(read_csv("data/responses.csv", show_col_types = FALSE) |> select(c((19+12+1):(19+12+32))))
}

#' Variable Names
#'
#' @description
#' This function returns the names of the variables (columns) in the dataset used in the package.
#'
#' @returns A character vector: the column names of the dataset used in the package.
#' @export
#'
#' @examples
#' get_var_names()
get_var_names <- function(){
  return(colnames(get_data()))
}
