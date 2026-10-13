# public_health_spatial_analysis
An R pipeline utilizing Kernel Density Estimation (KDE) to map and analyze regional public health data hotspots

# Public Health Geospatial Hotspot Analysis in R

## Overview
This project provides a reproducible R programming pipeline to identify and map spatial clusters of critical health events (such as overdoses or emergency responses). By transforming raw coordinates into actionable geographic risk tiers, this script allows organizations to deploy resources more effectively.

## Key Technical Features
* **Spatial Data Pipeline:** Integrates `sf` (Simple Features) data structures with traditional `tidyverse` data manipulation workflows.
* **Geospatial Projection:** Converts coordinate systems from standard GPS data (WGS84 / EPSG:4326) to projected coordinate grids (Pseudo-Mercator / EPSG:3857) to ensure precise distance-based metrics.
* **Advanced Visualizations:** Uses `sfhotspot` to calculate **Kernel Density Estimation (KDE)** clusters and builds publication-ready map layers using `ggplot2`.
* **API Integration:** Leverages `tidygeocoder` to programmatically clean and convert raw physical addresses into map coordinates using the US Census and OpenStreetMap APIs.

## Privacy & HIPAA Compliance Notice
To protect PHI, source datasets (`.rds` and `.xlsx` files) are omitted from this public repository. 

**Code Reproducibility:** The script includes an automated data-masking fallback. If local source files are not detected, the script automatically synthesizes mock geographic coordinates within the county bounding. This allows data scientists to execute code and see it function without exposing real data.
