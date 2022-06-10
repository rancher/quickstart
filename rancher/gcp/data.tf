# Data for GCP module

# GCP data
# ----------------------------------------------------------

# Use latest SLES 15
data "google_compute_image" "sles" {
  family  = "sles-15"
  project = "suse-cloud"
}
