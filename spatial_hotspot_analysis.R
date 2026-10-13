# ==============================================================================
# Project: Public Health Geospatial Hotspot Analysis
# Objective: Map and analyze spatial clusters of events to inform 
#            resource allocation.
# ==============================================================================

# 1. ENVIRONMENT SETUP & DEPENDENCIES
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, sf, sfhotspot, tigris, tidygeocoder, openxlsx, janitor)

# 2. DATA ACQUISITION & INTEGRATION
# Fetch 2020 Census Tracts for Your County, CA (FIPS code 105)
yourcounty_tracts_2020 <- tigris::tracts(year = "2020", state = "CA", county = "105", progress_bar = FALSE)

# Ingest Your County Event Data (with Portfolio Safe Fallback)
death_data_path <- "Your county event file goes here.rds"

if (file.exists(death_data_path)) {
  yourcounty_od_map <- readRDS(event_data_path) %>% 
    select(lat = RESIDENCE_LATITUDE_193, lon = RESIDENCE_LONGITUDE_194)
} else {
  set.seed(42) # Ensure reproducible fake coordinates within Your County limits
  yourcounty_od_map <- tibble(
    lat = runif(60, min = 40.3, max = 41.0),
    lon = runif(60, min = -123.3, max = -122.7)
  )
}

# Filter out missing spatial values and convert to Spatial (sf) Object
yourcounty_od_sf <- yourcounty_od_map %>% 
  filter(!is.na(lat) & !is.na(lon)) %>% 
  st_as_sf(coords = c("lon", "lat"), crs = 4326)


# 3. SPATIAL HOTSPOT ANALYTICS
# Transform to Projected Coordinate System (EPSG:3857) for distance-based KDE
od_kde <- yourcounty_od_sf %>% 
  st_transform(crs = 3857) %>% 
  hotspot_kde(bandwidth_adjust = 0.5) %>% 
  filter(kde > 0)


# 4. PUBLICATION-READY VISUALIZATION
ggplot() + 
  geom_sf(data = yourcounty_tracts_2020, fill = "snow3", color = "white", linewidth = 0.2) +
  geom_sf(data = od_kde, mapping = aes(fill = kde), alpha = 0.75, colour = NA) +
  scale_fill_distiller(palette = "YlOrRd", direction = 1) + 
  labs(
    title    = "Event Density Analysis",
    subtitle = "Your County County Spatial Hotspots",
    fill     = "Density Index\n(Number Events)"
  ) +
  theme_void() +
  theme(
    plot.title    = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, face = "italic"),
    legend.position = "right"
  )
