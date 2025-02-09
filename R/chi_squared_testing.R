#' Visualize the Chi-Squared Test
#'
#' @description
#' This function conducts a Chi-squared test on the variables var_1 and var_2.
#' It does so by displaying two generated null distributions: one using a theoretical approximation
#' (shown by the continuous line) and another using resampling methods (shown by the bars). Finally,
#' it draws a vertical red line, representing the observed statistic of the test.
#'
#' For resampling, the method "permute" is used, like in https://cran.r-project.org/web/packages/infer/vignettes/chi_squared.html.
#' It is described as follows: "The randomization approach approximates the null distribution by permuting the response and explanatory variables,
#' so that each person’s educational attainment is matched up with a random income from the sample in order to break up any association between the two."
#'
#' @param var_1 the column name of the first variable in the dataset.
#' @param var_2 the column name of the second variable in the dataset.
#'
#' @returns A plot that visualizes the result of the test.
#' @export
#'
#' @examples
#' visualize_chi_squared_test("Mathematics", "Biology")
visualize_chi_squared_test <- function(var_1, var_2){
  df <- get_var_data(var_1, var_2)
  observed_indep_statistic <- df |>
    specify(col_1 ~ col_2) |>
    hypothesize(null = "independence") |>
    calculate(stat = "Chisq")
  df |>
    specify(col_1 ~ col_2) |>
    hypothesize(null = "independence") |>
    generate(reps = 1000, type = "permute") |>
    calculate(stat = "Chisq") |>
    visualize(method = "both") +
    shade_p_value(observed_indep_statistic,
                  direction = "greater")
}

#' Test the Conditions for the Chi-Squared Test
#'
#' @param var_1 the column name of the first variable in the dataset.
#' @param var_2 the column name of the second variable in the dataset.
#'
#' @returns A list:
#' - `verdict`: A boolean that is set to `TRUE` if the conditions for the test have been met.
#' - `message`: A character string describing why the conditions for the test have not been met or
#'   signaling that they have been met.
#' - `contingency_table`: The contingency table used for the test.
#' - `independent_table`: The frequency table under the assumption that the variables are independent.
#' @export
#'
#' @examples
#' chi_squared_conditions_test("Fun with friends", "Politics")$message
chi_squared_conditions_test <- function(var_1, var_2){
  data <- get_var_data(var_1, var_2)
  contingency_table <- table(data$col_1, data$col_2)
  table_sum <- sum(contingency_table)
  n <- nrow(contingency_table)
  m <- ncol(contingency_table)

  independent_table <- contingency_table
  for (i in 1:n) {
    for (j in 1:m)
    {
      row_sum <- as.numeric(sum(contingency_table[i, ]))
      col_sum <- as.numeric(sum(contingency_table[, j]))
      independent_table[i, j] = row_sum * col_sum / table_sum
    }
  }

  bad_frequencies <- sum(contingency_table < 10)
  bad_independence_numbs <- sum(independent_table < 1)
  small_independent_numbs_perc <- as.numeric(sum(independent_table < 5)) /
    length(contingency_table) * 100

  conditions_met <- TRUE
  message <- ""
  if (bad_frequencies > 0) {
    conditions_met <- FALSE
    message <- "Error: All frequencies must be greater than or equal 10"
  }
  if (bad_independence_numbs > 0) {
    conditions_met -> FALSE
    message <- paste(message, "Error: All numbers of independence must be greater than or equal 1", sep = "\n")
  }
  if (small_independent_numbs_perc > 20) {
    conditions_met <- FALSE
    message <- paste(message, "Error: Less than 20 percent of all numbers of independence must be smaller than 5", sep = "\n")
  }

  if(conditions_met){
    message <- "The conditions for the test have been met."
  }

  return(list(verdict = conditions_met, message = message, contingency_table = contingency_table, independent_table = independent_table))
}

#' Chi-Squared Test
#'
#' @description
#' Conducts a Chi-squared test on the variables `var_1` and `var_2`.
#'
#'
#' @param var_1 the column name of the first variable in the dataset.
#' @param var_2 the column name of the second variable in the dataset.
#'
#' @returns A list that contains the results of the test:
#' - `statistic`: The Chi-squared statistic.
#' - `chisq_df`: The degrees of freedom.
#' - `p_value`: The p-value.
#' @export
#'
#' @examples
#' chi_squared_test("Pets", "Dancing")
chi_squared_test <-  function(var_1, var_2){
  return(chisq_test(get_var_data(var_1, var_2), col_1 ~ col_2))
}

#' Extreme Chi-Squared Statistic Values of a Variable
#'
#' @description
#' Helps to discover which variables give the smallest or biggest Chi-squared statistic values
#' when conducting the Chi-squared test with the variable `var`.
#' Variables are included in the results only if they meet the conditions for the Chi-squared test.
#'
#'
#' @param var the column name of the variable in the dataset.
#' @param M the number of extreme values to display.
#' @param biggest_chisq_vals whether to show the biggest Chi-squared statistics (`TRUE`) or
#'   the smallest (`FALSE`).
#'
#' @returns A data frame with columns `var_name` and `chi_sq_val`. The data frame
#'   includes the variables that give the smallest or biggest Chi-squared statistic values
#'   when conducting the Chi-squared test with the variable `var`.
#' @export
#'
#' @examples
#' var_extreme_chisq_stat_vals("Mathematics", M = 5, biggest_chisq_vals = TRUE)
var_extreme_chisq_stat_vals <- function(var, M = 3, biggest_chisq_vals = FALSE) {
  df <- data.frame(var_name = get_var_names()) |>
    filter(var_name != var) |>
    filter(
      sapply(var_name, function(col) {
        chi_squared_conditions_test(var, col)$verdict
      })
    ) |>
    mutate(
      chisq_val = sapply(var_name, function(col) {
        chi_squared_test(var, col)$statistic
      })
    )
  if (biggest_chisq_vals) {
    df <- df |> mutate(rank = min_rank(desc(chisq_val)))
  } else{
    df <- df |> mutate(rank = min_rank(chisq_val))
  }
  df |>
    filter(rank <= M) |>
    arrange(rank) |>
    select(-c(rank))
}
