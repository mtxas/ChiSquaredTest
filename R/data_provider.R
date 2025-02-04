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
  return(read_csv(path_package("chisquaredtest", "data", "responses.csv"), show_col_types = FALSE) |> select(c((19+12+1):(19+12+32))))
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

#' Get Data for Two Variables
#'
#' @description
#' Returns the data for the analysis of two columns in the dataset.
#' The returned data excludes NA entries.
#'
#' @param var_1 the column name of the first variable in the dataset.
#' @param var_2 the column name of the second variable in the dataset.
#'
#' @returns A data frame with two columns: "col_1" and "col_2". For i = 1, 2, the column
#' "col_i" contains entries of the form "Very/Fairly/Not much interested in <var_i>".
#' These entries correspond to values 5/4-3/2-1 in the original dataset.
#'
#' @export
#'
#' @examples
#' my_var_data <- get_var_data("Mathematics", "Biology")
#' table(my_var_data$col_1, my_var_data$col_2)
get_var_data <- function(var_1, var_2){
  get_data() |>
    filter(!is.na(!!sym(var_1)), !is.na(!!sym(var_2))) |>
    mutate(col_1 = paste(ifelse(!!sym(var_1) >= 5, "Very", ifelse(!!sym(var_1) >= 3, "Fairly", "Not much")), " interested in \"", var_1, "\"", sep = ""),
           col_2 = paste(ifelse(!!sym(var_2) >= 5, "Very", ifelse(!!sym(var_2) >= 3, "Fairly", "Not much")), " interested in \"", var_2, "\"", sep = "")) |>
    select(col_1, col_2)
}

#' Get Data for a Variable
#'
#' @description
#' Returns the data for the analysis of a column in the dataset.
#' The returned data excludes NA entries.
#'
#' @param var the column name of the variable in the dataset.
#'
#' @returns A data frame with one column: `col`. It contains entries of the form
#' "Very/Fairly/Not much interested in <column_name_of_variable>". These entries correspond to values 5/4-3/2-1
#' in the original dataset.
#'
#' @export
#'
#' @examples
#' my_var_data <- get_one_var_data("Psychology")
#' table(my_var_data$col)
get_one_var_data <- function(var){
  get_data() |>
    filter(!is.na(!!sym(var))) |>
    mutate(col = paste(ifelse(!!sym(var) >= 5, "Very", ifelse(!!sym(var) >= 3, "Fairly", "Not much")), " interested in \"", var, "\"", sep = "")) |>
    select(col)
}


