
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

Nun veranschaulichen wir kurz, welche Spalten es gibt. (Diese zu
betrachten könnte für den Nutzer hilfreich sein, um zu wissen, welche
Möglichkeiten er für seine persönliche Analyse hat.)

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

Weiterhin soll auf die Problematik eingegangen werden, dass der
Datensatz aus einer Perspektive betrachtet relativ wenige Einträge
enthält. Nämlich, wenn wir Chi-Quadrat-Tests durchführen wollen, müssen
die Einträge in der Häufigkeitstabelle mindestens eine gewisse Größe
haben. Wie man erkennt, haben die Befragten ihr Engagement mit den
Kategorien von 1 bis 5 bewertet („Not interested 1-2-3-4-5 Very
interested“). Daher wurde die Entscheidung getroffen, die Einträge
umzubenennen. „Very/Fairly/Not much interested in X“ korrespondiert mit
den Zahlen 5/4-3/2-1 auf der Skala. Dies erkennt man an den Funktionen
`get_var_data` und `get_one_var_data`, die wesentlich bei der Analyse
verwendet werden.

``` r
get_var_data("Medicine", "Internet")
#> # A tibble: 1,001 × 2
#>    col_1                                 col_2                                
#>    <chr>                                 <chr>                                
#>  1 "Fairly interested in \"Medicine\""   "Very interested in \"Internet\""    
#>  2 "Not much interested in \"Medicine\"" "Fairly interested in \"Internet\""  
#>  3 "Not much interested in \"Medicine\"" "Fairly interested in \"Internet\""  
#>  4 "Not much interested in \"Medicine\"" "Fairly interested in \"Internet\""  
#>  5 "Fairly interested in \"Medicine\""   "Not much interested in \"Internet\""
#>  6 "Fairly interested in \"Medicine\""   "Fairly interested in \"Internet\""  
#>  7 "Very interested in \"Medicine\""     "Not much interested in \"Internet\""
#>  8 "Not much interested in \"Medicine\"" "Very interested in \"Internet\""    
#>  9 "Not much interested in \"Medicine\"" "Not much interested in \"Internet\""
#> 10 "Not much interested in \"Medicine\"" "Very interested in \"Internet\""    
#> # ℹ 991 more rows
```

## 1.5 Weitere Funktionen

Weitere wichtige Funktionen werden im Verlauf der Analyse vorgestellt.
Die Details der Funktionen werden dabei nicht erklärt, aber sie können
in der Dokumentation, z.B. mit `?visualize_chi_squared_test`,
nachgelesen werden.

## 1.6 „Alte Experimente und Materialien“ Ordner

Dieser enthält nichts Relevantes für die Analyse, gibt mir jedoch mehr
Einsicht aus älteren persönlichen Experimenten und Materialien zur
R-Programmierung.

# 2. Installation

## 2.1 Installation und Aufladung des Pakets

Das Paket kann mit dem folgenden Befehl installiert werden.

``` r
remotes::install_gitlab("00000000014BADCE/chisquaredtest", auth_token = "glpat-s_hG6kgpx_CY7Pb4VbXm", host = "gitlab.lrz.de")
```

Weiter lässt es sich mit der folgenden Zeile laden.

``` r
library(chisquaredtest)
```

## 2.2 Aufladung von anderen Paketen

Um das Paket zu benutzen, muss man noch weitere Pakete laden bzw.
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

## 3.1 Numerische Beschreibung

Für den Chi-Quadrat Test brauchen wir, dass die Häufigkeiten bei
„Very/Fairly/Not much“ groß genug sind, damit sie auch in der
Häufigkeistabelle beim Chi-Quadrat-Test nicht zu klein sind. Die
Häufigkeiten liefert uns die Funktion `one_var_freq_table`. Durch Aufruf
dieser Funktion erhalten wir zusätzlich einen besseren Überblick über
unseren Datensatz.

``` r
for(col_name in get_var_names()){
  print(one_var_freq_table(col_name))
}
#> 
#>   Fairly interested in "History" Not much interested in "History" 
#>                              493                              309 
#>     Very interested in "History" 
#>                              206 
#> 
#>   Fairly interested in "Psychology" Not much interested in "Psychology" 
#>                                 494                                 338 
#>     Very interested in "Psychology" 
#>                                 173 
#> 
#>   Fairly interested in "Politics" Not much interested in "Politics" 
#>                               390                               513 
#>     Very interested in "Politics" 
#>                               106 
#> 
#>   Fairly interested in "Mathematics" Not much interested in "Mathematics" 
#>                                  319                                  589 
#>     Very interested in "Mathematics" 
#>                                   99 
#> 
#>   Fairly interested in "Physics" Not much interested in "Physics" 
#>                              252                              698 
#>     Very interested in "Physics" 
#>                               57 
#> 
#>   Fairly interested in "Internet" Not much interested in "Internet" 
#>                               496                                44 
#>     Very interested in "Internet" 
#>                               466 
#> 
#>   Fairly interested in "PC" Not much interested in "PC" 
#>                         457                         343 
#>     Very interested in "PC" 
#>                         204 
#> 
#>   Fairly interested in "Economy Management" 
#>                                         375 
#> Not much interested in "Economy Management" 
#>                                         505 
#>     Very interested in "Economy Management" 
#>                                         125 
#> 
#>   Fairly interested in "Biology" Not much interested in "Biology" 
#>                              319                              526 
#>     Very interested in "Biology" 
#>                              159 
#> 
#>   Fairly interested in "Chemistry" Not much interested in "Chemistry" 
#>                                187                                696 
#>     Very interested in "Chemistry" 
#>                                117 
#> 
#>   Fairly interested in "Reading" Not much interested in "Reading" 
#>                              367                              360 
#>     Very interested in "Reading" 
#>                              277 
#> 
#>   Fairly interested in "Geography" Not much interested in "Geography" 
#>                                483                                342 
#>     Very interested in "Geography" 
#>                                176 
#> 
#>   Fairly interested in "Foreign languages" 
#>                                        522 
#> Not much interested in "Foreign languages" 
#>                                        143 
#>     Very interested in "Foreign languages" 
#>                                        340 
#> 
#>   Fairly interested in "Medicine" Not much interested in "Medicine" 
#>                               302                               557 
#>     Very interested in "Medicine" 
#>                               146 
#> 
#>   Fairly interested in "Law" Not much interested in "Law" 
#>                          297                          641 
#>     Very interested in "Law" 
#>                           71 
#> 
#>   Fairly interested in "Cars" Not much interested in "Cars" 
#>                           346                           498 
#>     Very interested in "Cars" 
#>                           162 
#> 
#>   Fairly interested in "Art exhibitions" 
#>                                      371 
#> Not much interested in "Art exhibitions" 
#>                                      516 
#>     Very interested in "Art exhibitions" 
#>                                      117 
#> 
#>   Fairly interested in "Religion" Not much interested in "Religion" 
#>                               305                               613 
#>     Very interested in "Religion" 
#>                                89 
#> 
#>   Fairly interested in "Countryside, outdoors" 
#>                                            518 
#> Not much interested in "Countryside, outdoors" 
#>                                            173 
#>     Very interested in "Countryside, outdoors" 
#>                                            312 
#> 
#>   Fairly interested in "Dancing" Not much interested in "Dancing" 
#>                              286                              571 
#>     Very interested in "Dancing" 
#>                              150 
#> 
#>   Fairly interested in "Musical instruments" 
#>                                          226 
#> Not much interested in "Musical instruments" 
#>                                          625 
#>     Very interested in "Musical instruments" 
#>                                          158 
#> 
#>   Fairly interested in "Writing" Not much interested in "Writing" 
#>                              195                              738 
#>     Very interested in "Writing" 
#>                               71 
#> 
#>   Fairly interested in "Passive sport" Not much interested in "Passive sport" 
#>                                    404                                    281 
#>     Very interested in "Passive sport" 
#>                                    310 
#> 
#>   Fairly interested in "Active sport" Not much interested in "Active sport" 
#>                                   367                                   321 
#>     Very interested in "Active sport" 
#>                                   318 
#> 
#>   Fairly interested in "Gardening" Not much interested in "Gardening" 
#>                                204                                744 
#>     Very interested in "Gardening" 
#>                                 55 
#> 
#>   Fairly interested in "Celebrities" Not much interested in "Celebrities" 
#>                                  357                                  577 
#>     Very interested in "Celebrities" 
#>                                   74 
#> 
#>   Fairly interested in "Shopping" Not much interested in "Shopping" 
#>                               482                               300 
#>     Very interested in "Shopping" 
#>                               226 
#> 
#>   Fairly interested in "Science and technology" 
#>                                             499 
#> Not much interested in "Science and technology" 
#>                                             295 
#>     Very interested in "Science and technology" 
#>                                             210 
#> 
#>   Fairly interested in "Theatre" Not much interested in "Theatre" 
#>                              453                              369 
#>     Very interested in "Theatre" 
#>                              180 
#> 
#>   Fairly interested in "Fun with friends" 
#>                                       296 
#> Not much interested in "Fun with friends" 
#>                                        23 
#>     Very interested in "Fun with friends" 
#>                                       687 
#> 
#>   Fairly interested in "Adrenaline sports" 
#>                                        402 
#> Not much interested in "Adrenaline sports" 
#>                                        408 
#>     Very interested in "Adrenaline sports" 
#>                                        197 
#> 
#>   Fairly interested in "Pets" Not much interested in "Pets" 
#>                           330                           324 
#>     Very interested in "Pets" 
#>                           352
```

Diese Darstellung ist natürlich nicht so attraktiv für das Auge. Später
werden wir durch grafisch einen netteren Überblick bekommen.

Wir bemerken geringe Zahlen bei z.B. „Gardening“, „Fun with friends“,
„Writing” und „Physics“. Wenn wir später mit diesen Kategorien
Chi-Quadrat Tests durchführen wollen, müssen wir besonders vorsichtig
sein. Dies begründet auch folgendes Beispiel:

``` r
var_freq_table("Mathematics", "Physics")
#>                                       
#>                                        Fairly interested in "Physics"
#>   Fairly interested in "Mathematics"                              143
#>   Not much interested in "Mathematics"                             67
#>   Very interested in "Mathematics"                                 41
#>                                       
#>                                        Not much interested in "Physics"
#>   Fairly interested in "Mathematics"                                162
#>   Not much interested in "Mathematics"                              514
#>   Very interested in "Mathematics"                                   20
#>                                       
#>                                        Very interested in "Physics"
#>   Fairly interested in "Mathematics"                             14
#>   Not much interested in "Mathematics"                            6
#>   Very interested in "Mathematics"                               37
```

``` r
chi_squared_conditions_test("Mathematics", "Physics")$message
#> [1] "Error: All frequencies must be greater than or equal 10"
```

Wir erkennen, dass das Paar „Mathematik mit Physik“ nicht ganz geeignet
für ein Chi-Quadrat Test ist. Hier ist eine der Voraussetzungen nicht
erfüllt, die in dem Buch *Taschenbuch Der Statistik* von Horst Rinne
gennant wird (siehe Quellen ganz unten).

Mit `chi_squared_conditions_test` können wir auch angucken, wie die
Häufigkeitstabelle unter der Unabhängigkeitsannahme aussieht. Eine
Voraussetzung ist ja, dass kein Eintrag in der Tabelle kleiner als 1
ist. Bei 1.00998 \> 1 wird dies knapp hier (siehe unten).

``` r
chi_squared_conditions_test("Fun with friends", "Internet")$independent_table
#>                                            
#>                                             Fairly interested in "Internet"
#>   Fairly interested in "Fun with friends"                         145.63673
#>   Not much interested in "Fun with friends"                        11.31637
#>   Very interested in "Fun with friends"                           336.04691
#>                                            
#>                                             Not much interested in "Internet"
#>   Fairly interested in "Fun with friends"                            12.99800
#>   Not much interested in "Fun with friends"                           1.00998
#>   Very interested in "Fun with friends"                              29.99202
#>                                            
#>                                             Very interested in "Internet"
#>   Fairly interested in "Fun with friends"                       137.36527
#>   Not much interested in "Fun with friends"                      10.67365
#>   Very interested in "Fun with friends"                         316.96108
```

Da wir ja Zusammenhänge mit Mathematik analysieren möchten, untersuchen
wir die entsprechenden Häufigkeitstabellen.

``` r
bad_names <- c("Mathematics", "Gardening", "Fun with friends", "Writing", "Physics")
for(col_name in get_var_names()){
  if(col_name %in% bad_names == FALSE) {
    print(var_freq_table("Mathematics", col_name))
  }
}
#>                                       
#>                                        Fairly interested in "History"
#>   Fairly interested in "Mathematics"                              179
#>   Not much interested in "Mathematics"                            275
#>   Very interested in "Mathematics"                                 38
#>                                       
#>                                        Not much interested in "History"
#>   Fairly interested in "Mathematics"                                 94
#>   Not much interested in "Mathematics"                              183
#>   Very interested in "Mathematics"                                   31
#>                                       
#>                                        Very interested in "History"
#>   Fairly interested in "Mathematics"                             46
#>   Not much interested in "Mathematics"                          129
#>   Very interested in "Mathematics"                               30
#>                                       
#>                                        Fairly interested in "Psychology"
#>   Fairly interested in "Mathematics"                                 170
#>   Not much interested in "Mathematics"                               288
#>   Very interested in "Mathematics"                                    35
#>                                       
#>                                        Not much interested in "Psychology"
#>   Fairly interested in "Mathematics"                                    95
#>   Not much interested in "Mathematics"                                 203
#>   Very interested in "Mathematics"                                      38
#>                                       
#>                                        Very interested in "Psychology"
#>   Fairly interested in "Mathematics"                                53
#>   Not much interested in "Mathematics"                              94
#>   Very interested in "Mathematics"                                  26
#>                                       
#>                                        Fairly interested in "Politics"
#>   Fairly interested in "Mathematics"                               155
#>   Not much interested in "Mathematics"                             195
#>   Very interested in "Mathematics"                                  39
#>                                       
#>                                        Not much interested in "Politics"
#>   Fairly interested in "Mathematics"                                 136
#>   Not much interested in "Mathematics"                               330
#>   Very interested in "Mathematics"                                    46
#>                                       
#>                                        Very interested in "Politics"
#>   Fairly interested in "Mathematics"                              28
#>   Not much interested in "Mathematics"                            63
#>   Very interested in "Mathematics"                                14
#>                                       
#>                                        Fairly interested in "Internet"
#>   Fairly interested in "Mathematics"                               160
#>   Not much interested in "Mathematics"                             305
#>   Very interested in "Mathematics"                                  29
#>                                       
#>                                        Not much interested in "Internet"
#>   Fairly interested in "Mathematics"                                   8
#>   Not much interested in "Mathematics"                                35
#>   Very interested in "Mathematics"                                     1
#>                                       
#>                                        Very interested in "Internet"
#>   Fairly interested in "Mathematics"                             151
#>   Not much interested in "Mathematics"                           245
#>   Very interested in "Mathematics"                                69
#>                                       
#>                                        Fairly interested in "PC"
#>   Fairly interested in "Mathematics"                         166
#>   Not much interested in "Mathematics"                       253
#>   Very interested in "Mathematics"                            37
#>                                       
#>                                        Not much interested in "PC"
#>   Fairly interested in "Mathematics"                            81
#>   Not much interested in "Mathematics"                         246
#>   Very interested in "Mathematics"                              15
#>                                       
#>                                        Very interested in "PC"
#>   Fairly interested in "Mathematics"                        71
#>   Not much interested in "Mathematics"                      85
#>   Very interested in "Mathematics"                          47
#>                                       
#>                                        Fairly interested in "Economy Management"
#>   Fairly interested in "Mathematics"                                         128
#>   Not much interested in "Mathematics"                                       209
#>   Very interested in "Mathematics"                                            36
#>                                       
#>                                        Not much interested in "Economy Management"
#>   Fairly interested in "Mathematics"                                           132
#>   Not much interested in "Mathematics"                                         330
#>   Very interested in "Mathematics"                                              42
#>                                       
#>                                        Very interested in "Economy Management"
#>   Fairly interested in "Mathematics"                                        57
#>   Not much interested in "Mathematics"                                      47
#>   Very interested in "Mathematics"                                          21
#>                                       
#>                                        Fairly interested in "Biology"
#>   Fairly interested in "Mathematics"                              111
#>   Not much interested in "Mathematics"                            170
#>   Very interested in "Mathematics"                                 37
#>                                       
#>                                        Not much interested in "Biology"
#>   Fairly interested in "Mathematics"                                153
#>   Not much interested in "Mathematics"                              328
#>   Very interested in "Mathematics"                                   43
#>                                       
#>                                        Very interested in "Biology"
#>   Fairly interested in "Mathematics"                             50
#>   Not much interested in "Mathematics"                           90
#>   Very interested in "Mathematics"                               19
#>                                       
#>                                        Fairly interested in "Chemistry"
#>   Fairly interested in "Mathematics"                                 79
#>   Not much interested in "Mathematics"                               85
#>   Very interested in "Mathematics"                                   23
#>                                       
#>                                        Not much interested in "Chemistry"
#>   Fairly interested in "Mathematics"                                  203
#>   Not much interested in "Mathematics"                                438
#>   Very interested in "Mathematics"                                     52
#>                                       
#>                                        Very interested in "Chemistry"
#>   Fairly interested in "Mathematics"                               35
#>   Not much interested in "Mathematics"                             59
#>   Very interested in "Mathematics"                                 23
#>                                       
#>                                        Fairly interested in "Reading"
#>   Fairly interested in "Mathematics"                              125
#>   Not much interested in "Mathematics"                            212
#>   Very interested in "Mathematics"                                 29
#>                                       
#>                                        Not much interested in "Reading"
#>   Fairly interested in "Mathematics"                                108
#>   Not much interested in "Mathematics"                              206
#>   Very interested in "Mathematics"                                   44
#>                                       
#>                                        Very interested in "Reading"
#>   Fairly interested in "Mathematics"                             84
#>   Not much interested in "Mathematics"                          167
#>   Very interested in "Mathematics"                               26
#>                                       
#>                                        Fairly interested in "Geography"
#>   Fairly interested in "Mathematics"                                173
#>   Not much interested in "Mathematics"                              272
#>   Very interested in "Mathematics"                                   36
#>                                       
#>                                        Not much interested in "Geography"
#>   Fairly interested in "Mathematics"                                   88
#>   Not much interested in "Mathematics"                                214
#>   Very interested in "Mathematics"                                     40
#>                                       
#>                                        Very interested in "Geography"
#>   Fairly interested in "Mathematics"                               56
#>   Not much interested in "Mathematics"                             97
#>   Very interested in "Mathematics"                                 22
#>                                       
#>                                        Fairly interested in "Foreign languages"
#>   Fairly interested in "Mathematics"                                        168
#>   Not much interested in "Mathematics"                                      295
#>   Very interested in "Mathematics"                                           58
#>                                       
#>                                        Not much interested in "Foreign languages"
#>   Fairly interested in "Mathematics"                                           37
#>   Not much interested in "Mathematics"                                         89
#>   Very interested in "Mathematics"                                             17
#>                                       
#>                                        Very interested in "Foreign languages"
#>   Fairly interested in "Mathematics"                                      114
#>   Not much interested in "Mathematics"                                    201
#>   Very interested in "Mathematics"                                         24
#>                                       
#>                                        Fairly interested in "Medicine"
#>   Fairly interested in "Mathematics"                               111
#>   Not much interested in "Mathematics"                             155
#>   Very interested in "Mathematics"                                  36
#>                                       
#>                                        Not much interested in "Medicine"
#>   Fairly interested in "Mathematics"                                 162
#>   Not much interested in "Mathematics"                               342
#>   Very interested in "Mathematics"                                    50
#>                                       
#>                                        Very interested in "Medicine"
#>   Fairly interested in "Mathematics"                              44
#>   Not much interested in "Mathematics"                            90
#>   Very interested in "Mathematics"                                12
#>                                       
#>                                        Fairly interested in "Law"
#>   Fairly interested in "Mathematics"                          116
#>   Not much interested in "Mathematics"                        148
#>   Very interested in "Mathematics"                             31
#>                                       
#>                                        Not much interested in "Law"
#>   Fairly interested in "Mathematics"                            183
#>   Not much interested in "Mathematics"                          393
#>   Very interested in "Mathematics"                               64
#>                                       
#>                                        Very interested in "Law"
#>   Fairly interested in "Mathematics"                         20
#>   Not much interested in "Mathematics"                       47
#>   Very interested in "Mathematics"                            4
#>                                       
#>                                        Fairly interested in "Cars"
#>   Fairly interested in "Mathematics"                           119
#>   Not much interested in "Mathematics"                         189
#>   Very interested in "Mathematics"                              37
#>                                       
#>                                        Not much interested in "Cars"
#>   Fairly interested in "Mathematics"                             137
#>   Not much interested in "Mathematics"                           316
#>   Very interested in "Mathematics"                                44
#>                                       
#>                                        Very interested in "Cars"
#>   Fairly interested in "Mathematics"                          62
#>   Not much interested in "Mathematics"                        81
#>   Very interested in "Mathematics"                            18
#>                                       
#>                                        Fairly interested in "Art exhibitions"
#>   Fairly interested in "Mathematics"                                      134
#>   Not much interested in "Mathematics"                                    204
#>   Very interested in "Mathematics"                                         32
#>                                       
#>                                        Not much interested in "Art exhibitions"
#>   Fairly interested in "Mathematics"                                        150
#>   Not much interested in "Mathematics"                                      309
#>   Very interested in "Mathematics"                                           55
#>                                       
#>                                        Very interested in "Art exhibitions"
#>   Fairly interested in "Mathematics"                                     34
#>   Not much interested in "Mathematics"                                   71
#>   Very interested in "Mathematics"                                       12
#>                                       
#>                                        Fairly interested in "Religion"
#>   Fairly interested in "Mathematics"                               115
#>   Not much interested in "Mathematics"                             155
#>   Very interested in "Mathematics"                                  33
#>                                       
#>                                        Not much interested in "Religion"
#>   Fairly interested in "Mathematics"                                 177
#>   Not much interested in "Mathematics"                               384
#>   Very interested in "Mathematics"                                    51
#>                                       
#>                                        Very interested in "Religion"
#>   Fairly interested in "Mathematics"                              26
#>   Not much interested in "Mathematics"                            48
#>   Very interested in "Mathematics"                                15
#>                                       
#>                                        Fairly interested in "Countryside, outdoors"
#>   Fairly interested in "Mathematics"                                            170
#>   Not much interested in "Mathematics"                                          305
#>   Very interested in "Mathematics"                                               40
#>                                       
#>                                        Not much interested in "Countryside, outdoors"
#>   Fairly interested in "Mathematics"                                               53
#>   Not much interested in "Mathematics"                                            101
#>   Very interested in "Mathematics"                                                 19
#>                                       
#>                                        Very interested in "Countryside, outdoors"
#>   Fairly interested in "Mathematics"                                           95
#>   Not much interested in "Mathematics"                                        177
#>   Very interested in "Mathematics"                                             40
#>                                       
#>                                        Fairly interested in "Dancing"
#>   Fairly interested in "Mathematics"                               96
#>   Not much interested in "Mathematics"                            167
#>   Very interested in "Mathematics"                                 23
#>                                       
#>                                        Not much interested in "Dancing"
#>   Fairly interested in "Mathematics"                                175
#>   Not much interested in "Mathematics"                              332
#>   Very interested in "Mathematics"                                   62
#>                                       
#>                                        Very interested in "Dancing"
#>   Fairly interested in "Mathematics"                             47
#>   Not much interested in "Mathematics"                           88
#>   Very interested in "Mathematics"                               14
#>                                       
#>                                        Fairly interested in "Musical instruments"
#>   Fairly interested in "Mathematics"                                           85
#>   Not much interested in "Mathematics"                                        120
#>   Very interested in "Mathematics"                                             21
#>                                       
#>                                        Not much interested in "Musical instruments"
#>   Fairly interested in "Mathematics"                                            181
#>   Not much interested in "Mathematics"                                          385
#>   Very interested in "Mathematics"                                               56
#>                                       
#>                                        Very interested in "Musical instruments"
#>   Fairly interested in "Mathematics"                                         53
#>   Not much interested in "Mathematics"                                       83
#>   Very interested in "Mathematics"                                           22
#>                                       
#>                                        Fairly interested in "Passive sport"
#>   Fairly interested in "Mathematics"                                    129
#>   Not much interested in "Mathematics"                                  245
#>   Very interested in "Mathematics"                                       30
#>                                       
#>                                        Not much interested in "Passive sport"
#>   Fairly interested in "Mathematics"                                       84
#>   Not much interested in "Mathematics"                                    170
#>   Very interested in "Mathematics"                                         26
#>                                       
#>                                        Very interested in "Passive sport"
#>   Fairly interested in "Mathematics"                                  103
#>   Not much interested in "Mathematics"                                163
#>   Very interested in "Mathematics"                                     42
#>                                       
#>                                        Fairly interested in "Active sport"
#>   Fairly interested in "Mathematics"                                   142
#>   Not much interested in "Mathematics"                                 200
#>   Very interested in "Mathematics"                                      25
#>                                       
#>                                        Not much interested in "Active sport"
#>   Fairly interested in "Mathematics"                                      87
#>   Not much interested in "Mathematics"                                   204
#>   Very interested in "Mathematics"                                        30
#>                                       
#>                                        Very interested in "Active sport"
#>   Fairly interested in "Mathematics"                                  89
#>   Not much interested in "Mathematics"                               182
#>   Very interested in "Mathematics"                                    44
#>                                       
#>                                        Fairly interested in "Celebrities"
#>   Fairly interested in "Mathematics"                                  110
#>   Not much interested in "Mathematics"                                219
#>   Very interested in "Mathematics"                                     28
#>                                       
#>                                        Not much interested in "Celebrities"
#>   Fairly interested in "Mathematics"                                    188
#>   Not much interested in "Mathematics"                                  317
#>   Very interested in "Mathematics"                                       69
#>                                       
#>                                        Very interested in "Celebrities"
#>   Fairly interested in "Mathematics"                                 20
#>   Not much interested in "Mathematics"                               52
#>   Very interested in "Mathematics"                                    2
#>                                       
#>                                        Fairly interested in "Shopping"
#>   Fairly interested in "Mathematics"                               161
#>   Not much interested in "Mathematics"                             278
#>   Very interested in "Mathematics"                                  41
#>                                       
#>                                        Not much interested in "Shopping"
#>   Fairly interested in "Mathematics"                                 102
#>   Not much interested in "Mathematics"                               154
#>   Very interested in "Mathematics"                                    44
#>                                       
#>                                        Very interested in "Shopping"
#>   Fairly interested in "Mathematics"                              56
#>   Not much interested in "Mathematics"                           155
#>   Very interested in "Mathematics"                                14
#>                                       
#>                                        Fairly interested in "Science and technology"
#>   Fairly interested in "Mathematics"                                             159
#>   Not much interested in "Mathematics"                                           295
#>   Very interested in "Mathematics"                                                42
#>                                       
#>                                        Not much interested in "Science and technology"
#>   Fairly interested in "Mathematics"                                                79
#>   Not much interested in "Mathematics"                                             201
#>   Very interested in "Mathematics"                                                  15
#>                                       
#>                                        Very interested in "Science and technology"
#>   Fairly interested in "Mathematics"                                            80
#>   Not much interested in "Mathematics"                                          89
#>   Very interested in "Mathematics"                                              41
#>                                       
#>                                        Fairly interested in "Theatre"
#>   Fairly interested in "Mathematics"                              154
#>   Not much interested in "Mathematics"                            256
#>   Very interested in "Mathematics"                                 42
#>                                       
#>                                        Not much interested in "Theatre"
#>   Fairly interested in "Mathematics"                                114
#>   Not much interested in "Mathematics"                              210
#>   Very interested in "Mathematics"                                   43
#>                                       
#>                                        Very interested in "Theatre"
#>   Fairly interested in "Mathematics"                             49
#>   Not much interested in "Mathematics"                          118
#>   Very interested in "Mathematics"                               13
#>                                       
#>                                        Fairly interested in "Adrenaline sports"
#>   Fairly interested in "Mathematics"                                        138
#>   Not much interested in "Mathematics"                                      224
#>   Very interested in "Mathematics"                                           39
#>                                       
#>                                        Not much interested in "Adrenaline sports"
#>   Fairly interested in "Mathematics"                                          111
#>   Not much interested in "Mathematics"                                        261
#>   Very interested in "Mathematics"                                             36
#>                                       
#>                                        Very interested in "Adrenaline sports"
#>   Fairly interested in "Mathematics"                                       70
#>   Not much interested in "Mathematics"                                    103
#>   Very interested in "Mathematics"                                         22
#>                                       
#>                                        Fairly interested in "Pets"
#>   Fairly interested in "Mathematics"                           107
#>   Not much interested in "Mathematics"                         188
#>   Very interested in "Mathematics"                              32
#>                                       
#>                                        Not much interested in "Pets"
#>   Fairly interested in "Mathematics"                             108
#>   Not much interested in "Mathematics"                           184
#>   Very interested in "Mathematics"                                32
#>                                       
#>                                        Very interested in "Pets"
#>   Fairly interested in "Mathematics"                         103
#>   Not much interested in "Mathematics"                       214
#>   Very interested in "Mathematics"                            35
```

Hier erkennen wir wieder schlechte Paare wie z.B. „Internet mit
Mathematik“. Da ist ein Eintrag sogar nur Eins! Weiter entstehen
Probleme mit „Celebrities“ und „Law“. Allerdings können wir die
„schlechte Kategorien“ noch so ausfiltrieren:

``` r
bad_names <- c("Mathematics")
for(col_name in get_var_names()){
  if(col_name != "Mathematics"){
    if(chi_squared_conditions_test("Mathematics", col_name)$verdict == FALSE){
      bad_names <- c(bad_names, col_name)
    }
  }
}
bad_names
#> [1] "Mathematics"      "Physics"          "Internet"         "Law"             
#> [5] "Writing"          "Gardening"        "Celebrities"      "Fun with friends"
```

Wenn man möchte, kann natürlich die Häufigkeiten nicht berücksichtigen
und trotzdem Tests später auch mit den `bad_names` Tests durchführen,
aber es ist natürlich empfohlen, mit `chi_squared_conditions_test` immer
zu überprüfen, ob die Voraussetzungen für einen Test zwischen zwei
Variablen erfüllt sind, denn sonst kann der Test (irgendwelche, aber)
falsche Ergebnisse liefern.

## 3.2 Grafische Beschreibung

Als eine passende Diagrammart, um die Verteilung von Häufigkeiten zu
veranschaulichen, bietet sich ein Kreisdiagramm an. Nun möchten wir
damit versuchen einen Überblick über den Datensatz zu bekommen, der
netter für das Auge ist, und den der Nutzer für seine persönliche
Analysen eventuell verwenden könnte. Um nicht wieder zu viel Platz zu
verbrauchen, betrachtet wir diesmal nur 3 andere Variablen, die uns
gefallen haben.

``` r
p1 <- one_var_pie_chart("Dancing")
p2 <- one_var_pie_chart("Biology")
p3 <- one_var_pie_chart("Politics")
combine_pie_charts(p1, p2, p3)
```

<img src="man/figures/README-unnamed-chunk-11-1.png" width="100%" /> Für
die Untersuchung von Zusammenhängen ist dies aber nicht die beste
Option. Deshalb wurde die Funktion `var_bar_chart` entwickelt.

``` r
b1 <- var_bar_chart("Mathematics", "Biology")
b2 <- var_bar_chart("Mathematics", "Dancing")
b3 <- var_bar_chart("Mathematics", "Politics")
combine_bar_charts(b1, b2, b3)
```

<img src="man/figures/README-unnamed-chunk-12-1.png" width="100%" /> \##
3.3 Kleine Diskussion der Ergebnisse

Hier „wackelt“ es am meisten bei „Politics“ und am wenigsten bei
„Dancing“. Es lässt sich folgende Reihenfolge vermuten (absteigende
Abhängigkeit mit Mathematik) Politik-Biologie-Tanzen. Dies überprüfen
wir weiter bei der induktiven Analyse.

# 4. Induktive Analyse

Was `visualize_chi_squared_test` eigentlich macht, kann man gut in der
Dokumentation mit `?visualize_chi_squared_test` nachlesen. Wir fügen
hier hinzu den Teil „Description“:

### Description

This function conducts a Chi-squared test on the variables var_1 and
var_2. It does so by displaying two generated null distributions: one
using a theoretical approximation (shown by the continuous line) and
another using resampling methods (shown by the bars). Finally, it draws
a vertical red line, representing the observed statistic of the test.

## 4.1 Durchführung der Tests

Wir benutzen natürlich `visualize_chi_squared_test` und können noch
zusätzliche Infos (unter anderem den p-Wert) mit `chi_squared_test`
erhalten.

``` r
visualize_chi_squared_test("Mathematics", "Biology")
#> Warning: Check to make sure the conditions have been met for the theoretical method.
#> infer currently does not check these for you.
```

<img src="man/figures/README-unnamed-chunk-13-1.png" width="100%" />

``` r
chi_squared_test("Mathematics", "Biology")
#> # A tibble: 1 × 3
#>   statistic chisq_df p_value
#>       <dbl>    <int>   <dbl>
#> 1      8.18        4  0.0853
```

Hier erhalten wir einen Fehler 1. Art von rund 9 Prozent. Wir können
fast sicher sein, dass die Variablen abhängig sind, doch nicht super,
super sicher (wie bei Politik, siehe unten).

``` r
visualize_chi_squared_test("Mathematics", "Dancing")
#> Warning: Check to make sure the conditions have been met for the theoretical method.
#> infer currently does not check these for you.
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" />

``` r
chi_squared_test("Mathematics", "Dancing")
#> # A tibble: 1 × 3
#>   statistic chisq_df p_value
#>       <dbl>    <int>   <dbl>
#> 1      2.10        4   0.718
```

Dies war ein Beispiel, wo man sogar vermutet, dass die Variablen
vielleicht unabhängig sind.

``` r
visualize_chi_squared_test("Mathematics", "Politics")
#> Warning: Check to make sure the conditions have been met for the theoretical method.
#> infer currently does not check these for you.
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

``` r
chi_squared_test("Mathematics", "Politics")
#> # A tibble: 1 × 3
#>   statistic chisq_df  p_value
#>       <dbl>    <int>    <dbl>
#> 1      22.7        4 0.000142
```

Hier können wir selbstbewusst sagen, dass die Variablen abhängig sind.

## 4.2 Bonus: Finde die „am meisten abhängigen/unabhängigen Variablen”

Die Rechnung mit `var_extreme_chisq_stat_vals` kann bis zu 30 Sekunden
dauern.

``` r
var_extreme_chisq_stat_vals("Mathematics", M = 5, biggest_chisq_vals = FALSE)
#>                var_name chisq_val
#> 1                  Pets  1.580251
#> 2               Dancing  2.097223
#> 3               Reading  4.942122
#> 4       Art exhibitions  5.629248
#> 5 Countryside, outdoors  5.956824
```

``` r
var_extreme_chisq_stat_vals("Mathematics", M = 32, biggest_chisq_vals = TRUE)
#>                  var_name chisq_val
#> 1                      PC 79.711811
#> 2  Science and technology 46.953319
#> 3      Economy Management 34.492575
#> 4               Chemistry 33.772975
#> 5                Politics 22.745604
#> 6                Shopping 22.028695
#> 7            Active sport 20.341519
#> 8                 History 17.410281
#> 9                Religion 16.594333
#> 10              Geography 13.409663
#> 11             Psychology 12.425607
#> 12                   Cars 11.798713
#> 13    Musical instruments 10.494323
#> 14          Passive sport  9.698663
#> 15               Medicine  9.597641
#> 16      Adrenaline sports  9.066309
#> 17                Biology  8.178146
#> 18      Foreign languages  6.761975
#> 19                Theatre  6.600596
#> 20  Countryside, outdoors  5.956824
#> 21        Art exhibitions  5.629248
#> 22                Reading  4.942122
#> 23                Dancing  2.097223
#> 24                   Pets  1.580251
```

Wichtige Bemerkung („warum gibt es nur 24 und nicht 32 Zeilen?“): es
werden Tests ausfiltriert, bei denen die Voraussetzungen für den
Chi-Quadrat Test nicht erfüllt sind.

# Quellen

<https://www.kaggle.com/datasets/miroslavsabo/young-people-survey?select=columns.csv>

<https://cran.r-project.org/web/packages/infer/vignettes/chi_squared.html>

Rinne, Horst. *Taschenbuch Der Statistik*. 4., vollst. überarb. und erw.
Aufl. Deutsch, 2008.
