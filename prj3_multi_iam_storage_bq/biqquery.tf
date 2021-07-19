# incremental dataset
locals {
  data_store_count = 2
}

resource "google_bigquery_dataset" "desc-incl-datasets" {
  count = local.data_store_count

  dataset_id    = "${format("%s%02d", "desc", count.index + 1)}"
  friendly_name = "${format("%s%02d", "desc", count.index + 1)}"
  location      = var.region
}

resource "google_bigquery_dataset" "dh-incl-datasets" {
  count = local.data_store_count

  dataset_id    = "${format("%s%02d", "dh", count.index + 1)}"
  friendly_name = "${format("%s%02d", "dh", count.index + 1)}"
  location      = var.region
}


# # fixed dataset
resource "google_bigquery_dataset" "fixed-datasets" {
  for_each = toset(["master", "sys_master", "temp"])

  dataset_id    = each.value
  friendly_name = each.value
  location      = var.region
}



# 権限のattach (storageと似た感じ)
