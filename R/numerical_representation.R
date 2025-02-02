#' Frequency Table for a Variable
#'
#' @description
#' Returns the frequency table for a variable, excluding NA entries.
#'
#' @param var the column name of the variable in the dataset.
#'
#' @returns The frequency table for the variable, excluding NA entries.
#' @export
#'
#' @examples
#' one_var_freq_table("Shopping")
one_var_freq_table <- function(var){
  table(get_one_var_data(var)$col)
}

#' Frequency Table for Two Variables
#'
#' @description
#' Returns the frequency table for two variables, excluding NA entries.
#'
#' @param var_1 the column name of the first variable in the dataset.
#' @param var_2 the column name of the second variable in the dataset.
#'
#' @returns A frequency table for the two variables, excluding NA entries.
#' @export
#'
#' @examples
#' var_freq_table("Adrenaline sports", "Cars")
var_freq_table <- function(var_1, var_2){
  data <- get_var_data(var_1, var_2)
  table(data$col_1, data$col_2)
}

