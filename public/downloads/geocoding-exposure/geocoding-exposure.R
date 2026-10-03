## ----setup----
knitr::opts_chunk$set(
  echo = TRUE, warning = TRUE, message = FALSE,
  fig.align = "center", fig.width = 8, fig.height = 5.5,
  dev = "ragg_png", dpi = 160, out.width = "100%"
)


## ----packages-----------------------------------------------------------------
library(sf)
library(terra)
library(dplyr)
library(tidyr)
library(purrr)
library(ggplot2)
library(readr)
library(stringr)
library(lubridate)

theme_set(theme_minimal(base_size = 12, base_family = "Times New Roman"))
dir.create("geocoding-output", showWarnings = FALSE)


## ----point-table--------------------------------------------------------------
locations <- tibble(
  address_id = c("A01", "A02", "A03", "A04"),
  lon = c(118.760, 118.775, 118.800, 118.790),
  lat = c(32.040, 32.060, 32.045, 32.075)
)

homes_ll <- st_as_sf(
  locations, coords = c("lon", "lat"), crs = 4326, remove = FALSE
)
homes_ll


## ----projection---------------------------------------------------------------
homes_m <- st_transform(homes_ll, 32650)
tibble(
  address_id = homes_m$address_id,
  easting_m = st_coordinates(homes_m)[, "X"],
  northing_m = st_coordinates(homes_m)[, "Y"]
)
st_crs(homes_m)$units_gdal


## ----inspect-sf---------------------------------------------------------------
st_bbox(homes_ll)
st_geometry_type(homes_ll)
st_is_valid(homes_ll)

homes_ll |>
  filter(address_id %in% c("A01", "A02")) |>
  select(address_id)

st_drop_geometry(homes_ll)


## ----sf-io--------------------------------------------------------------------
st_write(
  homes_ll, "geocoding-output/homes_demo.gpkg",
  layer = "homes", delete_layer = TRUE, quiet = TRUE
)
homes_read <- st_read(
  "geocoding-output/homes_demo.gpkg", layer = "homes", quiet = TRUE
)
stopifnot(
  nrow(homes_read) == nrow(homes_ll),
  st_crs(homes_read) == st_crs(homes_ll)
)


## ----spatial-objects----------------------------------------------------------
study_bbox <- st_bbox(homes_m)
study_bbox[c("xmin", "ymin")] <-
  floor(study_bbox[c("xmin", "ymin")] / 500) * 500 - 2000
study_bbox[c("xmax", "ymax")] <-
  ceiling(study_bbox[c("xmax", "ymax")] / 500) * 500 + 2000
study_area <- st_as_sfc(study_bbox)

zones <- st_sf(
  zone_id = c("West", "East"),
  area_pm25 = c(24, 32),
  geometry = st_make_grid(study_area, n = c(2, 1))
)
road <- st_sf(
  road_id = "R01",
  geometry = st_sfc(st_linestring(matrix(
    c(study_bbox["xmin"], study_bbox["ymin"] + 1500,
      study_bbox["xmax"], study_bbox["ymax"] - 1500),
    ncol = 2, byrow = TRUE
  )), crs = st_crs(homes_m))
)
buffers_500 <- st_buffer(homes_m, dist = 500)


## ----geometry-map----
geometry_map <- ggplot() +
  geom_sf(data = zones, aes(fill = zone_id), color = "grey45", alpha = 0.35) +
  geom_sf(data = buffers_500, fill = NA, linetype = 2, linewidth = 0.6) +
  geom_sf(data = road, color = "#A74722", linewidth = 1) +
  geom_sf(data = homes_m, shape = 21, fill = "white", size = 3) +
  geom_sf_label(data = homes_m, aes(label = address_id), nudge_y = 750, size = 4) +
  scale_fill_manual(values = c(West = "#78B7C5", East = "#E6C978"),
                    labels = c(West = "西侧分区", East = "东侧分区")) +
  coord_sf(datum = st_crs(homes_m)) +
  labs(x = "东向坐标（m）", y = "北向坐标（m）", fill = "教学分区")
geometry_map


## ----polygon-join-------------------------------------------------------------
zone_hits <- st_intersects(homes_m, zones)
tibble(address_id = homes_m$address_id, n_zones = lengths(zone_hits))
stopifnot(all(lengths(zone_hits) == 1L))

homes_zone <- st_join(homes_m, zones, join = st_intersects, left = TRUE)
homes_zone |>
  st_drop_geometry() |>
  select(address_id, zone_id, area_pm25)


## ----distance-area------------------------------------------------------------
road_distance <- st_distance(homes_m, road)
distance_table <- tibble(
  address_id = homes_m$address_id,
  distance_to_road_m = as.numeric(road_distance[, 1]),
  buffer_area_km2 = as.numeric(st_area(buffers_500)) / 1e6
)
knitr::kable(distance_table, digits = 3)


## ----address-input------------------------------------------------------------
events_raw <- tibble(
  event_id = sprintf("E%02d", 1:7),
  person_id = c("P01", "P02", "P03", "P04", "P05", "P01", "P06"),
  event_date = as.Date(c(
    "2025-01-15", "2025-01-16", "2025-01-17", "2025-01-18",
    "2025-01-19", "2025-01-22", "2025-01-20"
  )),
  address_raw = c(
    "教学市 甲路1号", "教学市乙路2号", "教学市丙路3号",
    "教学市丁路4号", "教学市某区", "教学市 甲路1号", ""
  )
)
events <- events_raw |>
  mutate(address_clean = na_if(str_squish(address_raw), ""))

address_book <- events |>
  filter(!is.na(address_clean)) |>
  distinct(address_clean) |>
  mutate(address_id = sprintf("A%02d", row_number()))

events <- events |>
  left_join(address_book, by = join_by(address_clean), relationship = "many-to-one")
knitr::kable(events)


## ----geocode-offline----------------------------------------------------------
geocode_review <- bind_rows(
  locations |>
    mutate(
      match_level = "教学门址", coord_source = "WGS84",
      review_status = "通过"
    ),
  tibble(
    address_id = "A05", lon = 118.780, lat = 32.055,
    match_level = "教学区级代表点", coord_source = "WGS84",
    review_status = "待复核"
  )
)

events_geo <- events |>
  left_join(geocode_review, by = join_by(address_id), relationship = "many-to-one") |>
  mutate(location_status = case_when(
    is.na(address_clean) ~ "地址缺失",
    is.na(lon) | is.na(lat) ~ "无坐标",
    review_status != "通过" ~ "定位待复核",
    !between(lon, -180, 180) | !between(lat, -90, 90) ~ "坐标越界",
    TRUE ~ "可匹配"
  ))
events_geo |> count(location_status, name = "事件数")


## ----parse-geocoder-----------------------------------------------------------
parse_tencent <- function(body, address_id) {
  status <- body$status
  if (is.null(status)) status <- NA_integer_
  result <- body$result
  lon <- result$location$lng
  lat <- result$location$lat
  level <- result$level
  if (is.null(lon)) lon <- NA_real_
  if (is.null(lat)) lat <- NA_real_
  if (is.null(level)) level <- NA_integer_
  tibble(
    address_id = address_id,
    api_status = as.integer(status),
    lon_source = as.numeric(lon), lat_source = as.numeric(lat),
    level = as.integer(level), coord_source = "GCJ-02",
    request_ok = !is.na(status) && status == 0,
    has_coordinates = is.finite(lon) && is.finite(lat)
  )
}

mock_success <- list(
  status = 0L,
  result = list(location = list(lng = 118.78, lat = 32.06), level = 9L)
)
mock_failure <- list(status = 120L)
bind_rows(
  parse_tencent(mock_success, "DEMO_OK"),
  parse_tencent(mock_failure, "DEMO_RETRY")
)


## ----live-geocoder-function---------------------------------------------------
query_tencent <- function(address, address_id) {
  key <- Sys.getenv("TENCENT_MAP_KEY")
  if (!nzchar(key)) stop("尚未设置 TENCENT_MAP_KEY。")

  response <- tryCatch(
    httr2::request("https://apis.map.qq.com/ws/geocoder/v1/") |>
      httr2::req_url_query(address = address, key = key) |>
      httr2::req_timeout(15) |>
      httr2::req_perform(),
    error = function(e) NULL
  )
  if (is.null(response)) {
    return(tibble(
      address_id = address_id, api_status = NA_integer_,
      lon_source = NA_real_, lat_source = NA_real_, level = NA_integer_,
      coord_source = "GCJ-02", request_ok = FALSE,
      has_coordinates = FALSE, transport_status = "请求失败",
      queried_at = as.character(Sys.time())
    ))
  }
  body <- httr2::resp_body_json(response, simplifyVector = FALSE)
  parse_tencent(body, address_id) |>
    mutate(transport_status = "已响应", queried_at = as.character(Sys.time()))
}


## ----geocode-quality----------------------------------------------------------
address_book |>
  left_join(geocode_review, by = join_by(address_id), relationship = "one-to-one") |>
  count(review_status, name = "地址数")

events_geo |>
  count(location_status, name = "事件数") |>
  mutate(proportion = 事件数 / sum(事件数))


## ----create-raster------------------------------------------------------------
pm_template <- rast(
  xmin = study_bbox["xmin"], xmax = study_bbox["xmax"],
  ymin = study_bbox["ymin"], ymax = study_bbox["ymax"],
  resolution = 500, crs = st_crs(homes_m)$wkt
)
cell_xy <- xyFromCell(pm_template, seq_len(ncell(pm_template)))
x_km <- (cell_xy[, 1] - study_bbox["xmin"]) / 1000
y_km <- (cell_xy[, 2] - study_bbox["ymin"]) / 1000
spatial_pm25 <- 18 + 1.3 * x_km + 0.7 * y_km +
  12 * exp(-((x_km - 4)^2 + (y_km - 4)^2) / 2)

pm_day <- setValues(pm_template, spatial_pm25)
names(pm_day) <- "pm25"
res(pm_day)
ext(pm_day)


## ----raster-map----
raster_table <- as.data.frame(pm_day, xy = TRUE)
exposure_map <- ggplot(raster_table, aes(x, y)) +
  geom_tile(aes(fill = pm25), color = "white", linewidth = 0.12) +
  geom_sf(data = buffers_500, inherit.aes = FALSE,
          fill = NA, linetype = 2, linewidth = 0.5) +
  geom_sf(data = homes_m, inherit.aes = FALSE,
          shape = 21, fill = "white", size = 3) +
  geom_sf_label(data = homes_m, inherit.aes = FALSE,
                aes(label = address_id), nudge_y = 750, size = 4) +
  scale_fill_viridis_c(name = "PM2.5\n(µg/m³)") +
  coord_sf(crs = st_crs(homes_m), datum = st_crs(homes_m)) +
  labs(x = "东向坐标（m）", y = "北向坐标（m）")
exposure_map


## ----save-cover----
dir.create("figure", showWarnings = FALSE)
ggsave("figure/geocoding-exposure-cover.png", exposure_map,
       width = 8, height = 5.5, dpi = 160, bg = "white")


## ----point-extract------------------------------------------------------------
homes_raster <- st_transform(homes_ll, crs(pm_day))
point_values <- terra::extract(pm_day, vect(homes_raster), method = "simple")

point_pm25 <- tibble(
  address_id = homes_raster$address_id[point_values$ID],
  pm25_simple = point_values$pm25
)
knitr::kable(point_pm25, digits = 2)


## ----extraction-comparison----------------------------------------------------
bilinear_values <- terra::extract(
  pm_day, vect(homes_raster), method = "bilinear"
)
buffer_values <- terra::extract(
  pm_day, vect(buffers_500), fun = mean, exact = TRUE, na.rm = FALSE
)
method_comparison <- point_pm25 |>
  left_join(
    tibble(address_id = homes_raster$address_id[bilinear_values$ID],
           pm25_bilinear = bilinear_values$pm25),
    by = join_by(address_id), relationship = "one-to-one"
  ) |>
  left_join(
    tibble(address_id = buffers_500$address_id[buffer_values$ID],
           pm25_buffer500 = buffer_values$pm25),
    by = join_by(address_id), relationship = "one-to-one"
  )
knitr::kable(method_comparison, digits = 2)


## ----extraction-plot----
method_comparison |>
  pivot_longer(starts_with("pm25_"), names_to = "method", values_to = "pm25") |>
  mutate(method = factor(method,
    levels = c("pm25_simple", "pm25_bilinear", "pm25_buffer500"),
    labels = c("所在像元", "双线性插值", "500 m 缓冲区")
  )) |>
  ggplot(aes(pm25, address_id, color = method, shape = method)) +
  geom_point(size = 3, position = position_dodge(width = 0.5)) +
  scale_color_manual(values = c("#176B74", "#A74722", "#6A5599")) +
  labs(x = "PM2.5 (µg/m³)", y = "地址", color = "提取方法", shape = "提取方法") +
  theme(legend.position = "bottom")


## ----daily-rasters------------------------------------------------------------
exposure_dates <- seq(as.Date("2024-12-25"), as.Date("2025-01-31"), by = "day")
pm_daily <- rast(map(seq_along(exposure_dates), function(j) {
  setValues(pm_template, spatial_pm25 + 4 * sin(j / 4) + 0.15 * j)
}))
names(pm_daily) <- paste0("pm25_", format(exposure_dates, "%Y%m%d"))
time(pm_daily) <- exposure_dates

layer_manifest <- tibble(
  exposure_date = as.Date(time(pm_daily)),
  layer_index = seq_len(nlyr(pm_daily)),
  layer_name = names(pm_daily),
  pollutant = "PM2.5", unit = "µg/m³", product = "teaching_simulation"
)
stopifnot(!anyDuplicated(layer_manifest$exposure_date))
knitr::kable(head(layer_manifest))


## ----daily-extraction---------------------------------------------------------
address_daily <- map(seq_len(nrow(layer_manifest)), function(j) {
  values_j <- terra::extract(
    pm_daily[[layer_manifest$layer_index[j]]],
    vect(homes_raster), method = "simple"
  )
  tibble(
    address_id = homes_raster$address_id[values_j$ID],
    exposure_date = layer_manifest$exposure_date[j],
    pm25 = values_j[[2]]
  )
}) |> list_rbind()

stopifnot(!anyDuplicated(address_daily[c("address_id", "exposure_date")]))
knitr::kable(head(address_daily), digits = 2)


## ----lag-table----------------------------------------------------------------
event_lags <- events_geo |>
  select(event_id, person_id, address_id, event_date, location_status) |>
  crossing(lag = 0:2) |>
  mutate(exposure_date = event_date - lag) |>
  left_join(
    address_daily, by = join_by(address_id, exposure_date),
    relationship = "many-to-one"
  )

event_lags |>
  filter(event_id == "E01") |>
  select(event_id, event_date, lag, exposure_date, pm25) |>
  knitr::kable(digits = 2)


## ----lag-summary--------------------------------------------------------------
event_wide <- event_lags |>
  select(event_id, lag, pm25) |>
  pivot_wider(names_from = lag, values_from = pm25, names_prefix = "pm25_lag")

event_window <- event_lags |>
  summarise(
    n_expected = n(), n_valid = sum(!is.na(pm25)),
    pm25_mean_lag02 = if (all(!is.na(pm25))) mean(pm25) else NA_real_,
    .by = event_id
  )

event_exposure <- events_geo |>
  select(event_id, person_id, address_id, event_date, location_status) |>
  left_join(event_wide, by = join_by(event_id), relationship = "one-to-one") |>
  left_join(event_window, by = join_by(event_id), relationship = "one-to-one")
knitr::kable(event_exposure, digits = 2)


## ----exposure-timeplot----
event_day <- events$event_date[events$event_id == "E01"]
address_daily |>
  filter(address_id == "A01") |>
  ggplot(aes(exposure_date, pm25)) +
  annotate("rect", xmin = event_day - 2.5, xmax = event_day + 0.5,
           ymin = -Inf, ymax = Inf, fill = "#E6C978", alpha = 0.35) +
  geom_line(color = "#176B74", linewidth = 0.8) +
  geom_point(color = "#176B74", size = 1.8) +
  geom_vline(xintercept = event_day, linetype = 2) +
  scale_x_date(date_breaks = "1 week", date_labels = "%m-%d") +
  labs(x = "日期（2024–2025）", y = "PM2.5 (µg/m³)")


## ----case-crossover-dates-----------------------------------------------------
month_days <- seq(
  floor_date(event_day, "month"),
  ceiling_date(event_day, "month") - days(1), by = "day"
)
reference_days <- month_days[wday(month_days) == wday(event_day)]
cc_dates <- tibble(
  event_id = "E01", address_id = "A01",
  index_date = reference_days,
  case = as.integer(reference_days == event_day)
)
knitr::kable(cc_dates)


## ----referent-timeline----
cc_dates |>
  mutate(day_type = factor(case, levels = c(0, 1), labels = c("参照日", "事件日"))) |>
  ggplot(aes(index_date, 1, color = day_type, shape = day_type)) +
  geom_hline(yintercept = 1, color = "grey75") +
  geom_point(size = 4) +
  scale_color_manual(values = c("#176B74", "#A74722")) +
  scale_shape_manual(values = c(16, 17)) +
  scale_x_date(breaks = reference_days, date_labels = "%m-%d") +
  scale_y_continuous(breaks = NULL) +
  labs(x = "日期（2025年）", y = NULL, color = NULL, shape = NULL) +
  theme(legend.position = "bottom", panel.grid = element_blank())


## ----case-crossover-lags------------------------------------------------------
cc_lags <- cc_dates |>
  crossing(lag = 0:2) |>
  mutate(exposure_date = index_date - lag) |>
  left_join(
    address_daily, by = join_by(address_id, exposure_date),
    relationship = "many-to-one"
  )
stopifnot(
  sum(cc_dates$case) == 1L,
  !anyDuplicated(cc_lags[c("event_id", "index_date", "lag")])
)
cc_lags |>
  select(index_date, case, lag, exposure_date, pm25) |>
  knitr::kable(digits = 2)


## ----case-crossover-wide------------------------------------------------------
cc_exposure <- cc_lags |>
  select(event_id, index_date, case, lag, pm25) |>
  pivot_wider(names_from = lag, values_from = pm25, names_prefix = "pm25_lag")
knitr::kable(cc_exposure, digits = 2)


## ----geotiff-io---------------------------------------------------------------
writeRaster(
  pm_day, "geocoding-output/pm25_demo.tif", overwrite = TRUE,
  wopt = list(gdal = "COMPRESS=LZW")
)
pm_read <- rast("geocoding-output/pm25_demo.tif")
pm_read


## ----crop-mask----------------------------------------------------------------
analysis_extent <- st_as_sfc(st_bbox(buffers_500))
pm_crop <- crop(pm_day, vect(analysis_extent))
pm_mask <- mask(pm_crop, vect(analysis_extent))
tibble(
  original_cells = ncell(pm_day),
  cropped_cells = ncell(pm_crop),
  masked_valid_cells = global(!is.na(pm_mask), "sum")[[1]]
)


## ----missing-cell-demo--------------------------------------------------------
pm_missing <- pm_day
missing_cell <- cellFromXY(pm_missing, st_coordinates(homes_raster)[1, , drop = FALSE])
pm_missing[missing_cell] <- NA_real_
missing_values <- terra::extract(pm_missing, vect(homes_raster), method = "simple")
tibble(
  address_id = homes_raster$address_id[missing_values$ID],
  pm25 = missing_values$pm25,
  missing = is.na(missing_values$pm25)
)


## ----buffer-coverage----------------------------------------------------------
buffer_cells <- terra::extract(
  pm_missing, vect(buffers_500), exact = TRUE, cells = TRUE
)
cell_area_m2 <- prod(res(pm_missing))
buffer_coverage <- buffer_cells |>
  summarise(
    valid_area_m2 = sum(fraction[!is.na(pm25)]) * cell_area_m2,
    mean_observed = if (any(!is.na(pm25))) {
      weighted.mean(pm25, fraction, na.rm = TRUE)
    } else {
      NA_real_
    },
    .by = ID
  ) |>
  mutate(
    address_id = buffers_500$address_id[ID],
    coverage = valid_area_m2 / as.numeric(st_area(buffers_500))[ID]
  )
knitr::kable(select(buffer_coverage, address_id, coverage, mean_observed), digits = 3)


## ----residence-weighting------------------------------------------------------
residence_demo <- tibble(
  person_id = c("P_DEMO", "P_DEMO"),
  address_id = c("A01", "A02"),
  days_at_address = c(120, 245),
  period_mean_pm25 = c(20, 30)
)
residence_demo |>
  summarise(
    total_days = sum(days_at_address),
    annual_mean_pm25 = weighted.mean(period_mean_pm25, days_at_address),
    .by = person_id
  )


## ----final-checks-------------------------------------------------------------
stopifnot(
  nrow(event_exposure) == nrow(events_raw),
  !anyDuplicated(event_exposure$event_id),
  !anyDuplicated(event_lags[c("event_id", "lag")]),
  all(event_lags$exposure_date == event_lags$event_date - event_lags$lag),
  all(event_exposure$n_expected == 3L),
  all(event_exposure$n_valid[event_exposure$location_status == "可匹配"] == 3L)
)

event_exposure |>
  summarise(
    n_events = n(),
    n_with_lag0 = sum(!is.na(pm25_lag0)),
    n_with_full_window = sum(n_valid == n_expected),
    .by = location_status
  ) |>
  knitr::kable()


## ----save-results-------------------------------------------------------------
write_csv(address_daily, "geocoding-output/address_daily_pm25.csv")
write_csv(event_exposure, "geocoding-output/event_exposure.csv")
write_csv(cc_exposure, "geocoding-output/case_crossover_exposure.csv")
write_csv(layer_manifest, "geocoding-output/layer_manifest.csv")
write_csv(events_geo, "geocoding-output/geocoding_review_demo.csv")


## ----session-info-------------------------------------------------------------
sessionInfo()
