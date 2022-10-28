locals {
  tables             = { for table in var.tables : table["table_id"] => table }
}

resource "google_bigquery_dataset" "main" {
  dataset_id                  = var.dataset_id
  friendly_name               = var.dataset_name
  description                 = var.description
  location                    = var.location
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  default_table_expiration_ms = var.default_table_expiration_ms
  project                     = var.project_id
  labels                      = var.dataset_labels

}

resource "google_bigquery_table" "main" {
  for_each            = local.tables
  dataset_id          = google_bigquery_dataset.main.dataset_id
  friendly_name       = each.key
  table_id            = each.key
  labels              = each.value["labels"]
  schema              = each.value["schema"]
  clustering          = each.value["clustering"]
  expiration_time     = each.value["expiration_time"]
  project             = var.project_id
  deletion_protection = var.deletion_protection

  dynamic "time_partitioning" {
    for_each = each.value["time_partitioning"] != null ? [each.value["time_partitioning"]] : []
    content {
      type                     = time_partitioning.value["type"]
      expiration_ms            = time_partitioning.value["expiration_ms"]
      field                    = time_partitioning.value["field"]
      require_partition_filter = time_partitioning.value["require_partition_filter"]
    }
  }
}