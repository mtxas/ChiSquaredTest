
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 1. Überblick

## 1.1 Zweck des Pakets

Dieses Paket hilft zu untersuchen, ob einige Interessen und Hobbys von
Personen abhängig von anderen Hobbys und Interessen sind. Dies wird
sowohl durch explorative als auch induktive Analysen erreicht
(insbesondere durch die Durchführung und Visualisierung von
Chi-Quadrat-Tests).

## 1.2 Eine (etwas persönliche) Motivation für die Analyse

Es hat mich gewundert, ob es Zusammenhänge zwischen verschiedenen Hobbys
und Interessen bei Personen gibt. Nämlich, wenn jemand an einer Sache
sehr bzw. ganz wenig interessiert ist, bedeutet dies, dass es mit einer
gewissen Wahrscheinlichkeit an einer anderen Aktivität eine niedrige,
mittelwertige oder große Begeisterung vorliegt? Sind die Ebene der
Auseinandersetzung mit Politik und die Ebene der Auseinandersetzung mit
Kunst voneinander unabhängig oder voneinander abhängig?

In der nachstehenden Untersuchung werde ich analysieren, wie abhängig
Mathematik mit anderen Hobbys und Interessen ist. Dies finde ich
spannend, da ich selbst Mathematik sehr mag und herausfinden möchte, ob
dies (statistisch) einen Einfluss darauf hat, ob mir oder anderen
Mathematiker:innen andere Sachen gefallen bzw. nicht gefallen. Das Paket
ist aber allgemeiner einsetzbar, d.h. man kann auch Abhängigkeiten nicht
nur mit Mathematik untersuchen.

## 1.3 Gewählter Datensatz

Es wird der Datensatz [Young People
Survey](https://www.kaggle.com/datasets/miroslavsabo/young-people-survey?select=columns.csv)
aus der Platform Kaggle verwendet.

Dabei gab es einige Gründe zu dieser Wahl. Erstens ist es natürlich gut,
dass der Datensatz Information über Hobbies und Interesse von Leute
enthält. Zweitens wurde die Umfrage von einer Universität organisiert,
weshalb die Daten wahrscheinlich etwas realistischer sind. Schließlich
ist der Datensatz nicht all zu klein, besitzt nämlich mehr als 1000
Zeilen.

Alle Teilnehmer der Umfrage waren slowakischer Nationalität und zwischen
15 und 30 Jahre alt. Der Datensatz enthält fehlende Werte, die bei der
Datenanalyse ausgeschlossen werden.

## 1.4 Datentransformationen

Da wir nur die Hobbys und Interessen untersuchen wollen, haben wir die
entsprechenden Spalten `select`iert. Unten befindet sich ein Überblick
über den Datensatz.

``` r
get_data()
#> # A tibble: 1,010 × 32
#>    History Psychology Politics Mathematics Physics Internet    PC
#>      <dbl>      <dbl>    <dbl>       <dbl>   <dbl>    <dbl> <dbl>
#>  1       1          5        1           3       3        5     3
#>  2       1          3        4           5       2        4     4
#>  3       1          2        1           5       2        4     2
#>  4       4          4        5           4       1        3     1
#>  5       3          2        3           2       2        2     2
#>  6       5          3        4           2       3        4     4
#>  7       3          3        1           1       1        2     1
#>  8       5          2        3           1       1        5     4
#>  9       3          2        1           1       1        1     1
#> 10       3          2        3           3       1        5     1
#> # ℹ 1,000 more rows
#> # ℹ 25 more variables: `Economy Management` <dbl>, Biology <dbl>,
#> #   Chemistry <dbl>, Reading <dbl>, Geography <dbl>, `Foreign languages` <dbl>,
#> #   Medicine <dbl>, Law <dbl>, Cars <dbl>, `Art exhibitions` <dbl>,
#> #   Religion <dbl>, `Countryside, outdoors` <dbl>, Dancing <dbl>,
#> #   `Musical instruments` <dbl>, Writing <dbl>, `Passive sport` <dbl>,
#> #   `Active sport` <dbl>, Gardening <dbl>, Celebrities <dbl>, Shopping <dbl>, …
```

Nun veranschaulichen wir uns noch kurz, was für Spalten es gibt. (Diese
anzuschauen könnte für den Nutzer hilfreich sein, um zu wissen, welche
Möglichkeiten es für seine persönliche Analyse gibt.)

``` r
get_var_names()
#>  [1] "History"                "Psychology"             "Politics"              
#>  [4] "Mathematics"            "Physics"                "Internet"              
#>  [7] "PC"                     "Economy Management"     "Biology"               
#> [10] "Chemistry"              "Reading"                "Geography"             
#> [13] "Foreign languages"      "Medicine"               "Law"                   
#> [16] "Cars"                   "Art exhibitions"        "Religion"              
#> [19] "Countryside, outdoors"  "Dancing"                "Musical instruments"   
#> [22] "Writing"                "Passive sport"          "Active sport"          
#> [25] "Gardening"              "Celebrities"            "Shopping"              
#> [28] "Science and technology" "Theatre"                "Fun with friends"      
#> [31] "Adrenaline sports"      "Pets"
```

Weiter soll man mit der Problematik, dass der Datensatz aus einer
Perspektive eigentlich relativ wenige Einträge hat. Nämlich, wenn wir
Chi-Quadrat Tests durchführen wollen, müssen die Einträge in der
Häufigkeitstabelle mindestens eine gewisse Größe haben. Wie man erkennt,
haben die Befragten ihr Engagement mit den Kategorien von 1 bis 5
bewertet („Not interested 1-2-3-4-5 Very interested“). Daher wurde die
Entscheidung getroffen, die Einträge zu umbenennen. Nämlich
korrespondiert “Very/Fairly/Not much interested in X” mit Zahlen
5/4-3/2-1 auf der Skala. Dies erkennt man bei den Funktionen
`get_var_names()` und `get_one_var_data()` die wesentlich bei der
Analyse verwendet werden.

``` r
?get_var_names
#> starting httpd help server ... done
```

# 2. Installation

## 2.1 Installation und Aufladung des Pakets

Das Paket kann man installieren durch das folgende Befehl.

``` r
remotes::install_gitlab("00000000014BADCE/chisquaredtest", auth_token = "glpat-s_hG6kgpx_CY7Pb4VbXm", host = "gitlab.lrz.de")
```

Weiter lässt es sich aufladen mit der folgenden Zeile.

``` r
library(chisquaredtest)
```

## 2.2 Aufladung von anderen Paketen

Um das Paket zu benutzen, muss man noch weitere Pakete aufladen bzw.
installieren. Dies geschieht durch folgenden Code.

``` r
if (!require(tidyverse)) {
  install.packages("tidyverse")
  library(tidyverse)
}

if (!require(gridExtra)) {
  install.packages("gridExtra")
  library(gridExtra)
}

if (!require(infer)) {
  install.packages("infer")
  library(infer)
}
```

# 3. Explorative Analyse

``` r
sample_function()
#> [1] 6
get_data()
#> # A tibble: 1,010 × 32
#>    History Psychology Politics Mathematics Physics Internet    PC
#>      <dbl>      <dbl>    <dbl>       <dbl>   <dbl>    <dbl> <dbl>
#>  1       1          5        1           3       3        5     3
#>  2       1          3        4           5       2        4     4
#>  3       1          2        1           5       2        4     2
#>  4       4          4        5           4       1        3     1
#>  5       3          2        3           2       2        2     2
#>  6       5          3        4           2       3        4     4
#>  7       3          3        1           1       1        2     1
#>  8       5          2        3           1       1        5     4
#>  9       3          2        1           1       1        1     1
#> 10       3          2        3           3       1        5     1
#> # ℹ 1,000 more rows
#> # ℹ 25 more variables: `Economy Management` <dbl>, Biology <dbl>,
#> #   Chemistry <dbl>, Reading <dbl>, Geography <dbl>, `Foreign languages` <dbl>,
#> #   Medicine <dbl>, Law <dbl>, Cars <dbl>, `Art exhibitions` <dbl>,
#> #   Religion <dbl>, `Countryside, outdoors` <dbl>, Dancing <dbl>,
#> #   `Musical instruments` <dbl>, Writing <dbl>, `Passive sport` <dbl>,
#> #   `Active sport` <dbl>, Gardening <dbl>, Celebrities <dbl>, Shopping <dbl>, …
```

``` r
p1 <- var_bar_chart("Mathematics", "Biology")
p2 <-  var_bar_chart("Mathematics", "Shopping")
p3 <- var_bar_chart("Mathematics", "Pets")
combine_bar_charts(p1, p2, p3)
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

``` r
p1 <- one_var_pie_chart("Art exhibitions")
p2 <- one_var_pie_chart("Chemistry")
p3 <- one_var_pie_chart("Dancing")
combine_pie_charts(p1, p2, p3)
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />

# 4. Induktive Analyse

``` r
visualize_chi_squared_test("Mathematics", "Biology")
#> Warning: Check to make sure the conditions have been met for the theoretical method.
#> infer currently does not check these for you.
```

<img src="man/figures/README-unnamed-chunk-8-1.png" width="100%" />

``` r
visualize_chi_squared_test("Pets", "Cars")
#> Warning: Check to make sure the conditions have been met for the theoretical method.
#> infer currently does not check these for you.
```

<img src="man/figures/README-unnamed-chunk-9-1.png" width="100%" />

``` r
visualize_chi_squared_test("Mathematics", "Physics")
#> Warning: Check to make sure the conditions have been met for the theoretical method.
#> infer currently does not check these for you.
```

<img src="man/figures/README-unnamed-chunk-10-1.png" width="100%" />
