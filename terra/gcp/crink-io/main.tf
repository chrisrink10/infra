provider "google" {
  region  = "${var.region}"
  project = "${var.project_id}"
  version = "~> 1.9"
}

resource "google_storage_bucket" "crink-io" {
  name          = "crink-io"
  location      = "US"
  storage_class = "MULTI_REGIONAL"

  versioning {
    enabled = false
  }

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
