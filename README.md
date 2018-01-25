
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sundry

[![Travis-CI Build
Status](https://travis-ci.org/DJAnderson07/sundry.svg?branch=master)](https://travis-ci.org/DJAnderson07/sundry)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/DJAnderson07/sundry?branch=master&svg=true)](https://ci.appveyor.com/project/DJAnderson07/sundry)

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
devtools::install_github("DJAnderson07/sundry")
```

## Examples

Below are a few examples of functions in the package.

### Quickly calculate descriptive stats

Quickly calculate descriptive stats for any set of variables.

``` r
library(dplyr)
library(sundry)
storms %>% 
  descrips(wind, pressure)
#> # A tibble: 2 x 6
#>   variable     n   min   max  mean    sd
#> * <chr>    <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 pressure 10010 882    1022 992    19.5
#> 2 wind     10010  10.0   160  53.5  26.2

storms %>% 
  group_by(year) %>% 
  descrips(wind, pressure)
#> # A tibble: 82 x 7
#>     year variable     n   min    max   mean    sd
#>  * <dbl> <chr>    <dbl> <dbl>  <dbl>  <dbl> <dbl>
#>  1  1975 pressure  86.0 963   1014    995   15.2 
#>  2  1975 wind      86.0  20.0  100     50.9 23.6 
#>  3  1976 pressure  52.0 957   1012    989   15.3 
#>  4  1976 wind      52.0  20.0  105     59.9 24.8 
#>  5  1977 pressure  53.0 926   1015    995   20.4 
#>  6  1977 wind      53.0  20.0  150     54.0 29.6 
#>  7  1978 pressure  54.0 980   1012   1006    6.64
#>  8  1978 wind      54.0  20.0   80.0   40.5 13.9 
#>  9  1979 pressure 301   924   1014    995   19.9 
#> 10  1979 wind     301    15.0  150     48.7 30.3 
#> # ... with 72 more rows

storms %>% 
  group_by(year) %>% 
  descrips(wind, pressure,
           .funs = funs(qtile25 = quantile(., 0.25),
                        median, 
                        qtile75 = quantile(., 0.75)))
#> # A tibble: 82 x 5
#>     year variable qtile25 median qtile75
#>  * <dbl> <chr>      <dbl>  <dbl>   <dbl>
#>  1  1975 pressure   984    997    1011  
#>  2  1975 wind        25.0   52.5    65.0
#>  3  1976 pressure   978    992    1000  
#>  4  1976 wind        38.8   60.0    80.0
#>  5  1977 pressure   994   1001    1010  
#>  6  1977 wind        30.0   45.0    70.0
#>  7  1978 pressure  1006   1007    1009  
#>  8  1978 wind        30.0   40.0    45.0
#>  9  1979 pressure   988   1002    1008  
#> 10  1979 wind        25.0   35.0    65.0
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
#>    fun   name    year month   day  hour   lat  long status  category  wind
#>    <chr> <chr>  <dbl> <dbl> <int> <dbl> <dbl> <dbl> <chr>   <ord>    <int>
#>  1 min   Bonnie  1986  6.00    28  6.00  36.5 -91.3 tropic… -1          10
#>  2 min   Bonnie  1986  6.00    28 12.0   37.2 -90.0 tropic… -1          10
#>  3 min   AL031…  1987  8.00    16 18.0   30.9 -83.2 tropic… -1          10
#>  4 min   AL031…  1987  8.00    17  0     31.4 -82.9 tropic… -1          10
#>  5 min   AL031…  1987  8.00    17  6.00  31.8 -82.3 tropic… -1          10
#>  6 min   Alber…  1994  7.00     7  0     32.7 -86.3 tropic… -1          10
#>  7 min   Alber…  1994  7.00     7  6.00  32.7 -86.6 tropic… -1          10
#>  8 min   Alber…  1994  7.00     7 12.0   32.8 -86.8 tropic… -1          10
#>  9 min   Alber…  1994  7.00     7 18.0   33.0 -87.0 tropic… -1          10
#> 10 max   Gilbe…  1988  9.00    14  0     19.7 -83.8 hurric… 5          160
#> 11 max   Wilma   2005 10.0     19 12.0   17.3 -82.8 hurric… 5          160
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
#>  1 min    Caro…  1975  9.00     1  6.00  25.2 -98.7 tropic… -1          20
#>  2 min    Caro…  1975  9.00     1 12.0   25.3 -99.0 tropic… -1          20
#>  3 max    Caro…  1975  8.00    31  0     24.0 -97.0 hurric… 3          100
#>  4 max    Caro…  1975  8.00    31  6.00  24.1 -97.5 hurric… 3          100
#>  5 min    Glor…  1976  9.00    26 12.0   23.0 -58.0 tropic… -1          20
#>  6 min    Glor…  1976  9.00    26 18.0   23.7 -58.1 tropic… -1          20
#>  7 median Belle  1976  8.00    10  6.00  41.0 -73.2 tropic… 0           60
#>  8 median Glor…  1976  9.00    28  6.00  27.5 -58.2 tropic… 0           60
#>  9 median Glor…  1976  9.00    28 12.0   27.8 -58.6 tropic… 0           60
#> 10 median Glor…  1976  9.00    28 18.0   28.2 -59.0 tropic… 0           60
#> # ... with 1,250 more rows, and 3 more variables: pressure <int>,
#> #   ts_diameter <dbl>, hu_diameter <dbl>
```
