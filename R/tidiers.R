#' Tidy summaries for melded data
#'
#' This is an approach for tidying Amelia imputed dataframes from Andrew Heiss
#'   <https://www.andrewheiss.com/blog/2018/03/08/amelia-broom-huxtable/>
#'
#' @param x melded object from Amelia
#' @param ... other arguments passed to methods
#' @param conf.int Return confidence intervals. Default is FALSE
#' @param conf.level Confidence level (if confidence intervals are use).
#'   Default is 0.95.
#'
#' @return tidy dataframe with pooled estimates from imputed data
#' @export
tidy.melded <- function(x,
                        ...,
                        conf.int = FALSE,
                        conf.level = 0.95) {
  # Get the df from one of the models
  model_degrees_freedom <- broom::glance(x[[1]])$df.residual

  # Create matrices of the estimates and standard errors
  params <- tibble::tibble(models = x) %>%
    dplyr::mutate(m = 1:dplyr::n(),
           tidied = models %>% purrr::map(tidy)) %>%
    tidyr::unnest(tidied) %>%
    dplyr::select(m,
                  term,
                  estimate,
                  std.error) %>%
    tidyr::gather(key,
                  value,
                  estimate,
                  std.error) %>%
    # Order the terms so that spread() keeps them in order
    dplyr::mutate(term = forcats::fct_inorder(term)) %>%
    tidyr::spread(term, value)

  just_coefs <- params %>%
    dplyr::filter(key == "estimate") %>%
    dplyr::select(-m, -key)

  just_ses <- params %>%
    dplyr::filter(key == "std.error") %>%
    dplyr::select(-m, -key)

  # Meld the coefficients with Rubin's rules
  coefs_melded <- Amelia::mi.meld(just_coefs, just_ses)

  # Create tidy output
  output <- as.data.frame(cbind(t(coefs_melded$q.mi),
                                t(coefs_melded$se.mi))) %>%
    purrr::set_names(nm = c("estimate", "std.error")) %>%
    tibble::rownames_to_column(var = "term") %>%
    # dplyr::mutate(term = rownames(.)) %>%
    dplyr::select(term, dplyr::everything()) %>%
    dplyr::mutate(statistic = estimate / std.error,
                  p.value = 2 * stats::pt(abs(statistic),
                                   model_degrees_freedom,
                                   lower.tail = FALSE))

  # Add confidence intervals if needed
  if (conf.int & conf.level) {
    # Convert conf.level to tail values (0.025 when it's 0.95)
    a <- (1 - conf.level) / 2

    output <- output %>%
      dplyr::mutate(
        conf.low = estimate + std.error * stats::qt(a, model_degrees_freedom),
        conf.high = estimate + std.error * stats::qt((1 - a), model_degrees_freedom)
        )
  }

  # tidy objects only have a data.frame class, not tbl_df or anything else
  class(output) <- "data.frame"
  output
}
