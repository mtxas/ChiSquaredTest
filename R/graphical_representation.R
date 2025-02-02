
#' Plot a Pie Chart for a Variable
#'
#'
#' @param var the column name of the variable in the dataset.
#'
#' @returns A pie chart for the variable.
#' @export
#'
#' @examples
#' one_var_pie_chart("Celebrities")
one_var_pie_chart <- function(var){
  get_one_var_data(var) |>
    count(col) |>
    ggplot(aes(x = "", y = n, fill = col)) +
    geom_bar(stat = "identity") +
    coord_polar(theta = "y") +
    theme_void() +
    ggtitle(paste("Pie Chart for \"", var, "\"", sep="")) +
    theme(legend.title = element_blank()) +
    geom_text(aes(label = n), position = position_stack(vjust = 0.5), size = 4, color = "white", fontface = "bold") +
    scale_fill_manual(values = c("blue3", "coral2", "chartreuse2"))
}

#' Plot a Bar Chart for Two Variables
#'
#' @param x_var the column name of the variable in the dataset that is used for the x-axis.
#' @param y_var the column name of the variable in the dataset that is used for the y-axis.
#'
#' @returns A bar chart for the variables.
#' @export
#'
#' @examples
#' var_bar_chart("History", "Science and technology")
var_bar_chart <- function(var_x, var_y){
  ggplot(get_var_data(var_y, var_x)) +
    geom_bar(aes(x = col_1, fill = col_2), position = "fill") +
    theme_minimal() +
    scale_fill_manual(values = c("blue3", "coral2", "chartreuse2")) +
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      legend.title = element_blank()
    ) +
    coord_flip()
}

#' Combine Bar Charts
#'
#' @param ... A sequence of bar charts.
#'
#' @returns A grid of bar charts arranged row by row.
#' @export
#'
#' @examples
#' p1 <- var_bar_chart("Mathematics", "Biology")
#' p2 <-  var_bar_chart("Mathematics", "Shopping")
#' p3 <- var_bar_chart("Mathematics", "Pets")
#' combine_bar_charts(p1, p2, p3)
combine_bar_charts <- function(...){
  grid.arrange(..., ncol = 1)
}

#' Combine Pie Charts
#'
#' @param ... A sequence of pie charts.
#'
#' @returns A grid of pie charts.
#' @export
#'
#' @examples
#' p1 <- one_var_pie_chart("Art exhibitions")
#' p2 <- one_var_pie_chart("Chemistry")
#' p3 <- one_var_pie_chart("Dancing")
#' combine_pie_charts(p1, p2, p3)
combine_pie_charts <- function(...){
  grid.arrange(..., ncol = 2)
}




