#' Summarise Amelia's multiple imputations
#'
#' A broom glance summary for multiple imputations from Andrew's blog post:
#' https://www.andrewheiss.com/blog/2018/03/07/amelia-tidy-melding/
#' Andrews note: This means properly melded parameters and the simple average
#' of the parameters of these models are roughly the same sake of simplicty
#' we just take the average here.
#'
#' @param x Amelia melded imputed data
#' @param ... other arguments passed to methods
#'
#' @return one line dataframe summary of the multiply imputed data
#' @export
glance.melded <- function(x, ...) {
  output <- tibble::tibble(models = x) %>%
    dplyr::mutate(glance = models %>% purrr::map(broom::glance)) %>%
    tidyr::unnest(glance) %>%
    dplyr::summarise_at(.vars = dplyr::vars(r.squared,
                                     adj.r.squared,
                                     sigma,
                                     statistic,
                                     p.value,
                                     df,
                                     logLik,
                                     AIC,
                                     BIC,
                                     deviance,
                                     df.residual),
                        .funs = list(mean = mean)) %>%
    dplyr::mutate(m = as.integer(length(x)))

  # glance objects only have a data.frame class, not tbl_df or anything else
  class(output) <- "data.frame"
  output
}
