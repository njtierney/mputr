
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mputr

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Travis build
status](https://travis-ci.org/njtierney/mputr.svg?branch=master)](https://travis-ci.org/njtierney/mputr)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/njtierney/mputr?branch=master&svg=true)](https://ci.appveyor.com/project/njtierney/mputr)
<!-- badges: end -->

The goal of mputr is to make it easier to deal with multiple imputation.

It is an **experimental package** that may end up being worked back into
`naniar`.

It’s goals are to:

  - Provide broom tidiers for multiple imputation objects (based on
    Andrew Heiss’s work
    [here](https://www.andrewheiss.com/blog/2018/03/07/amelia-tidy-melding/),
    and
    [here](https://www.andrewheiss.com/blog/2018/03/08/amelia-broom-huxtable/))
  - Provide helpers for exploring multiple imputations
  - Potentially provide an interface similar to `simputation`, but for
    multiple imputation.

## Installation

``` r
# install.packages("remotes")
remotes::install_github("njtierney/mputr")
```

\]
