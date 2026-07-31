library(mathmodels)
library(dplyr)
library(tidyr)
library(ggplot2)

sir_result <- model_sir(
  init = c(S = 990, I = 10, R = 0),
  params = c(beta = 0.15, gamma = 0.10),
  times = seq(0, 100, by = 0.5)
)

sir_plot_data <- sir_result |>
  pivot_longer(
    cols = c(S, I, R),
    names_to = "compartment",
    values_to = "population"
  ) |>
  mutate(
    compartment = factor(
      compartment,
      levels = c("S", "I", "R"),
      labels = c("易感者 S", "感染者 I", "移出者 R")
    )
  )

sir_plot <- ggplot(
  sir_plot_data,
  aes(x = time, y = population, colour = compartment)
) +
  geom_line(linewidth = 0.9) +
  scale_colour_manual(values = c("#3b6f8f", "#c55a3d", "#6e7f51")) +
  labs(x = "时间", y = "人数", colour = NULL) +
  theme_classic(base_size = 10, base_family = "Microsoft YaHei") +
  theme(legend.position = "bottom")

ggsave(
  filename = file.path("doc", "images", "mathmodels-sir-preview.png"),
  plot = sir_plot,
  width = 140,
  height = 88,
  units = "mm",
  dpi = 300,
  bg = "white"
)

# Validate the non-figure examples used in the tutorial against 0.0.11.
evaluation_data <- tibble(
  gain = c(80, 75, 90, 85),
  cost = c(12, 10, 15, 11),
  reliability = c(0.91, 0.88, 0.94, 0.90)
)
evaluation_weight <- entropy_weight(
  evaluation_data,
  index = c("+", "-", "+")
)
evaluation_score <- topsis(
  evaluation_data,
  w = evaluation_weight$w,
  index = c("+", "-", "+")
)
stopifnot(length(evaluation_score) == nrow(evaluation_data))

regression_fit <- reg_lm(mpg ~ wt + hp + am, data = mtcars)
regression_diagnostics <- reg_diagnostics(regression_fit)
regression_generated_prediction <- reg_predict(regression_fit, n_new = 2)
regression_custom_prediction <- predict(
  regression_fit$model,
  newdata = data.frame(
    wt = c(2.5, 3.0),
    hp = c(110, 150),
    am = c(1, 0)
  ),
  interval = "prediction"
)
stopifnot(
  nrow(regression_generated_prediction$predictions) == 2,
  nrow(regression_custom_prediction) == 2
)

passengers <- as_ts_df(log(AirPassengers))
time_series_fit <- ts_sarima(passengers)
time_series_forecast <- ts_forecast(time_series_fit, h = 12)
forecast_plot <- plot_ts_forecast(passengers, time_series_forecast)
residual_plot <- plot_ts_residuals(time_series_fit)
stopifnot(
  nrow(time_series_forecast) == 12,
  inherits(forecast_plot, "ggplot"),
  inherits(residual_plot, "ggplot")
)

sir_metrics <- epi_metrics(
  sir_result,
  beta = 0.15,
  gamma = 0.10,
  N = 1000
)
compartment_plot <- plot_compartments(
  sir_result,
  compartments = c("S", "I", "R")
)
stopifnot(
  isTRUE(all.equal(sir_metrics$R0, 1.5)),
  inherits(compartment_plot, "ggplot")
)

logistic_result <- ode_solver(
  init = c(N = 10),
  equations = c(N = "r * N * (1 - N / K)"),
  params = c(r = 0.35, K = 500),
  times = seq(0, 30, by = 0.2)
)
stopifnot(
  all(c("time", "N") %in% names(logistic_result))
)

observed <- tibble(
  x = c(0, 1, 2, 3),
  y = c(0, 1, 1.5, 1.8)
)

interp_result <- interp_spline(
  x = observed$x,
  y = observed$y,
  xout = seq(0, 3, by = 0.05)
)

interpolation_plot <- ggplot(interp_result, aes(x = x, y = y)) +
  geom_line(linewidth = 0.9, colour = "#3b6f8f") +
  geom_point(
    data = observed,
    aes(x = x, y = y),
    inherit.aes = FALSE,
    size = 2.4,
    colour = "#c55a3d"
  ) +
  labs(x = "x", y = "插值结果") +
  theme_classic(base_size = 10, base_family = "Microsoft YaHei")

ggsave(
  filename = file.path("doc", "images", "mathmodels-interpolation-preview.png"),
  plot = interpolation_plot,
  width = 120,
  height = 82,
  units = "mm",
  dpi = 300,
  bg = "white"
)

stopifnot(nrow(interp_result) == 61)
