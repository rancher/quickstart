# Data for GCP module

# GCP data
# ----------------------------------------------------------

# Use latest Ubuntu 18.04 Image
data "google_compute_image" "ubuntu" {
  family  = "ubuntu-1804-lts"
  project = "ubuntu-os-cloud"
}
