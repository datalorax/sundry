
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sundry

[![Travis-CI Build
Status](https://travis-ci.org/datalorax/sundry.svg?branch=master)](https://travis-ci.org/datalorax/sundry)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/4bmb4eqscdf3p6vb?svg=true)](https://ci.appveyor.com/project/DJAnderson07/sundry)
[![codecov](https://codecov.io/gh/datalorax/sundry/branch/master/graph/badge.svg)](https://codecov.io/gh/datalorax/sundry)

The *sundry* package is a personal R package filled with functions that
make my life a little easier when working on day-to-day analyses. Most
of the functions in the package are designed to be friendly with the
[tidyverse](https://www.tidyverse.org) and thus are pipe friendly
(`%>%`), and work with other functions like `dplyr::group_by`. The
package is somewhat perpetually under development.

## Installation

You can install sundry from github with:

``` r
# install.packages("devtools")
devtools::install_github("datalorax/sundry")
```

## Examples

Below are a few examples of functions in the package.

### Batch import data and bind into a single data frame

Maybe my favorite function in the package is the `read_files` function,
which will read in *n* datasets and, if possible bind them together into
a single tibble (data frame). The function uses `rio::import`, which
makes it really nice because you don’t have to worry about file types
basically at all, and you can even read in data of different types all
at once.

``` r
library(sundry)
library(tidyverse)
#> ── Attaching packages ─────────────────────────────────────────────────────── tidyverse 1.2.1 ──
#> ✔ ggplot2 3.0.0.9000     ✔ purrr   0.2.5     
#> ✔ tibble  1.4.2          ✔ dplyr   0.7.7     
#> ✔ tidyr   0.8.2          ✔ stringr 1.3.1     
#> ✔ readr   1.1.1          ✔ forcats 0.3.0
#> ── Conflicts ────────────────────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
by_species <- iris %>%
  split(.$Species) %>%
  map(select, -Species)

str(by_species)
#> List of 3
#>  $ setosa    :'data.frame':  50 obs. of  4 variables:
#>   ..$ Sepal.Length: num [1:50] 5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#>   ..$ Sepal.Width : num [1:50] 3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>   ..$ Petal.Length: num [1:50] 1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>   ..$ Petal.Width : num [1:50] 0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#>  $ versicolor:'data.frame':  50 obs. of  4 variables:
#>   ..$ Sepal.Length: num [1:50] 7 6.4 6.9 5.5 6.5 5.7 6.3 4.9 6.6 5.2 ...
#>   ..$ Sepal.Width : num [1:50] 3.2 3.2 3.1 2.3 2.8 2.8 3.3 2.4 2.9 2.7 ...
#>   ..$ Petal.Length: num [1:50] 4.7 4.5 4.9 4 4.6 4.5 4.7 3.3 4.6 3.9 ...
#>   ..$ Petal.Width : num [1:50] 1.4 1.5 1.5 1.3 1.5 1.3 1.6 1 1.3 1.4 ...
#>  $ virginica :'data.frame':  50 obs. of  4 variables:
#>   ..$ Sepal.Length: num [1:50] 6.3 5.8 7.1 6.3 6.5 7.6 4.9 7.3 6.7 7.2 ...
#>   ..$ Sepal.Width : num [1:50] 3.3 2.7 3 2.9 3 3 2.5 2.9 2.5 3.6 ...
#>   ..$ Petal.Length: num [1:50] 6 5.1 5.9 5.6 5.8 6.6 4.5 6.3 5.8 6.1 ...
#>   ..$ Petal.Width : num [1:50] 2.5 1.9 2.1 1.8 2.2 2.1 1.7 1.8 1.8 2.5 ...

# export as three different file types
rio::export(by_species$setosa, "setosa.csv")
rio::export(by_species$versicolor, "versicolor.xlsx")
rio::export(by_species$virginica, "virginica.sav")

# import them all back in as a single data frame
d <- read_files()
d
#> # A tibble: 150 x 5
#>    file   Sepal.Length Sepal.Width Petal.Length Petal.Width
#>    <chr>         <dbl>       <dbl>        <dbl>       <dbl>
#>  1 setosa     5.100000         3.5          1.4         0.2
#>  2 setosa     4.9              3            1.4         0.2
#>  3 setosa     4.7              3.2          1.3         0.2
#>  4 setosa     4.600000         3.1          1.5         0.2
#>  5 setosa     5                3.6          1.4         0.2
#>  6 setosa     5.4              3.9          1.7         0.4
#>  7 setosa     4.600000         3.4          1.4         0.3
#>  8 setosa     5                3.4          1.5         0.2
#>  9 setosa     4.4              2.9          1.4         0.2
#> 10 setosa     4.9              3.1          1.5         0.1
#> # ... with 140 more rows
d %>% 
  count(file)
#> # A tibble: 3 x 2
#>   file           n
#>   <chr>      <int>
#> 1 setosa        50
#> 2 versicolor    50
#> 3 virginica     50

fs::file_delete(c("setosa.csv", "versicolor.xlsx", "virginica.sav"))
```

The first argument is the directory, and defaults to the current working
directory. There’s also an optional `pat` argument you can supply to
read in only files with a specified pattern. You can also optionally
have the files read in as a list, rather than binding the data frames
together.

### Quickly calculate descriptive stats

Quickly calculate descriptive stats for any set of variables.

``` r
library(dplyr)
library(sundry)
storms %>% 
  descrips(wind, pressure)
#> # A tibble: 2 x 6
#>   variable     n   min   max      mean       sd
#>   <chr>    <dbl> <dbl> <dbl>     <dbl>    <dbl>
#> 1 pressure 10010   882  1022 992.1390  19.51678
#> 2 wind     10010    10   160  53.49500 26.21387

storms %>% 
  group_by(year) %>% 
  descrips(wind, pressure)
#> # A tibble: 82 x 7
#>     year variable     n   min   max       mean        sd
#>    <dbl> <chr>    <dbl> <dbl> <dbl>      <dbl>     <dbl>
#>  1  1975 pressure    86   963  1014  994.6279  15.20530 
#>  2  1975 wind        86    20   100   50.87209 23.60448 
#>  3  1976 pressure    52   957  1012  988.7692  15.25678 
#>  4  1976 wind        52    20   105   59.90385 24.78319 
#>  5  1977 pressure    53   926  1015  995.3585  20.42443 
#>  6  1977 wind        53    20   150   53.96226 29.55371 
#>  7  1978 pressure    54   980  1012 1005.833    6.635383
#>  8  1978 wind        54    20    80   40.46296 13.88186 
#>  9  1979 pressure   301   924  1014  994.8372  19.87369 
#> 10  1979 wind       301    15   150   48.67110 30.31603 
#> # ... with 72 more rows

storms %>% 
  group_by(year) %>% 
  descrips(wind, pressure,
           .funs = funs(qtile25 = quantile(., 0.25),
                        median, 
                        qtile75 = quantile(., 0.75)))
#> # A tibble: 82 x 5
#>     year variable qtile25 median qtile75
#>    <dbl> <chr>      <dbl>  <dbl>   <dbl>
#>  1  1975 pressure  984.5   997   1010.75
#>  2  1975 wind       25      52.5   65   
#>  3  1976 pressure  978.5   992   1000.25
#>  4  1976 wind       38.75   60     80   
#>  5  1977 pressure  994    1001   1010   
#>  6  1977 wind       30      45     70   
#>  7  1978 pressure 1006    1007   1009   
#>  8  1978 wind       30      40     45   
#>  9  1979 pressure  988    1002   1008   
#> 10  1979 wind       25      35     65   
#> # ... with 72 more rows
```

### Remove empty rows from specific columns

This function is similar to `janitor::remove_empty_rows`, but allows you
to pass a set of columns (rather than looking across all columns). Rows
will be removed that are missing across all
columns.

``` r
d <- rio::import("http://www.oregon.gov/ode/educator-resources/assessment/TestResults2017/pagr_schools_ela_tot_ecd_ext_gnd_lep_1617.xlsx",
            setclass = "tbl_df",
            na = c("--", "*")) %>% 
  janitor::clean_names()

d %>% 
  select(district_id, number_level_4:percent_level_1)
#> # A tibble: 23,760 x 9
#>    district_id number_level_4 percent_level_4 number_level_3
#>          <dbl> <chr>          <chr>           <chr>         
#>  1        2063 <NA>           <NA>            <NA>          
#>  2        2063 <NA>           <NA>            <NA>          
#>  3        2063 <NA>           <NA>            <NA>          
#>  4        2063 <NA>           <NA>            <NA>          
#>  5        2063 <NA>           <NA>            <NA>          
#>  6        2063 <NA>           <NA>            <NA>          
#>  7        2063 <NA>           <NA>            <NA>          
#>  8        2063 <NA>           <NA>            <NA>          
#>  9        2063 <NA>           <NA>            <NA>          
#> 10        2063 <NA>           <NA>            <NA>          
#> # ... with 23,750 more rows, and 5 more variables: percent_level_3 <chr>,
#> #   number_level_2 <chr>, percent_level_2 <chr>, number_level_1 <chr>,
#> #   percent_level_1 <chr>
```

The data above have missing data data across many columns, but every row
has at least some valid entries. Suppose I was only interested in data
on schools with proficiency data.

``` r
d %>% 
  rm_empty_rows(number_level_4:percent_level_1) %>% 
  select(district_id, number_level_4:percent_level_1) 
#> # A tibble: 15,081 x 9
#>    district_id number_level_4 percent_level_4    number_level_3
#>          <dbl> <chr>          <chr>              <chr>         
#>  1        2113 5              45.5               5             
#>  2        2113 5              29.4               8             
#>  3        2113 2              20                 5             
#>  4        2113 5              33.299999999999997 7             
#>  5        2113 2              20                 5             
#>  6        2113 0              0                  6             
#>  7        2113 7              53.8               5             
#>  8        2113 5              41.7               4             
#>  9        2113 5              41.7               6             
#> 10        2113 -              -                  -             
#> # ... with 15,071 more rows, and 5 more variables: percent_level_3 <chr>,
#> #   number_level_2 <chr>, percent_level_2 <chr>, number_level_1 <chr>,
#> #   percent_level_1 <chr>
```

The above returns all the rows that are not missing across the full set
of variables supplied (rows with partial missing are still returned).
The function can also be provided without any column arguments, and the
function will then mimic the behavior or `janitor::remove_empty_rows`.

### Filter by Functions

Select rows according to functions. For example, select only the rows
with the minimum and maximum values of a specific variable.

``` r
storms %>%
 filter_by_funs(wind, funs(min, max))
#> # A tibble: 11 x 14
#>    fun   name    year month   day  hour    lat  long status category  wind
#>    <chr> <chr>  <dbl> <dbl> <int> <dbl>  <dbl> <dbl> <chr>  <ord>    <int>
#>  1 min   Bonnie  1986     6    28     6 36.5   -91.3 tropi… -1          10
#>  2 min   Bonnie  1986     6    28    12 37.2   -90   tropi… -1          10
#>  3 min   AL031…  1987     8    16    18 30.9   -83.2 tropi… -1          10
#>  4 min   AL031…  1987     8    17     0 31.4   -82.9 tropi… -1          10
#>  5 min   AL031…  1987     8    17     6 31.8   -82.3 tropi… -1          10
#>  6 min   Alber…  1994     7     7     0 32.7   -86.3 tropi… -1          10
#>  7 min   Alber…  1994     7     7     6 32.7   -86.6 tropi… -1          10
#>  8 min   Alber…  1994     7     7    12 32.800 -86.8 tropi… -1          10
#>  9 min   Alber…  1994     7     7    18 33     -87   tropi… -1          10
#> 10 max   Gilbe…  1988     9    14     0 19.7   -83.8 hurri… 5          160
#> 11 max   Wilma   2005    10    19    12 17.3   -82.8 hurri… 5          160
#> # ... with 3 more variables: pressure <int>, ts_diameter <dbl>,
#> #   hu_diameter <dbl>

storms %>%
  group_by(year) %>%
  filter_by_funs(wind, funs(min, median, max)) %>%
  arrange(year)
#> # A tibble: 1,260 x 14
#> # Groups:   year [41]
#>    fun    name   year month   day  hour   lat  long status  category  wind
#>    <chr>  <chr> <dbl> <dbl> <int> <dbl> <dbl> <dbl> <chr>   <ord>    <int>
#>  1 min    Caro…  1975     9     1     6  25.2 -98.7 tropic… -1          20
#>  2 min    Caro…  1975     9     1    12  25.3 -99   tropic… -1          20
#>  3 max    Caro…  1975     8    31     0  24   -97   hurric… 3          100
#>  4 max    Caro…  1975     8    31     6  24.1 -97.5 hurric… 3          100
#>  5 min    Glor…  1976     9    26    12  23   -58   tropic… -1          20
#>  6 min    Glor…  1976     9    26    18  23.7 -58.1 tropic… -1          20
#>  7 median Belle  1976     8    10     6  41   -73.2 tropic… 0           60
#>  8 median Glor…  1976     9    28     6  27.5 -58.2 tropic… 0           60
#>  9 median Glor…  1976     9    28    12  27.8 -58.6 tropic… 0           60
#> 10 median Glor…  1976     9    28    18  28.2 -59   tropic… 0           60
#> # ... with 1,250 more rows, and 3 more variables: pressure <int>,
#> #   ts_diameter <dbl>, hu_diameter <dbl>
```


Here are my comments - Joe Nese
