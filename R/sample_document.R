#' Sample Function
#'
#' @param x An integer
#'
#' @returns An almost random number.
#' @export
#'
#' @examples
#' sample_function()
#' sample_function(3)
sample_function <- function(x = 5){
  return(x+1)
}

# getwd()
# Env loeschen
# load_all()
# Alt + Ctrl + Shift + R: Insert Oxygen Skeleton (or Code > Insert Oxygen Skeleton)
# document()
# @export macht es visible fuer den Nutzer. Wenn man die Funktion
# nicht fuer den Nutzer geben moechte, dann @export wegnehmen.
# Dokumentation Files sind in /man
# Nachdem wir jetzt irgendwas gemacht haben (ich glaube, DESCRIPTION geandert,
# hat sich auch README.md geandert)
# bitte nutzen use_readme_rmd(), damit auch eine README.RMD Datei erstellt wird, nicht nur README.md
# git add .
# git status
# git commit -m "my message"
# git push
# Vllt moechte man Daten speichern:
# x <- sample(1:100, 50, replace = TRUE)
# library(devtools)
# use_data(x)
# Es wird ein Folder data erstellt und eine Datei x.rda
# Diese kann dann jemand spaeter benutzen.
# Man kann auch machen:
# df <- data.frame(x)
# use_data(df)
# (es wird df.rda erstellt)
