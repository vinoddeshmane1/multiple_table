/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "bigquery" {
  source                      = "../"
  dataset_id                  = "demo_dev_dataset"
  dataset_name                = "demo_dev_dataset"
  description                 = "demo-app"
  delete_contents_on_destroy  = var.delete_contents_on_destroy
  default_table_expiration_ms = var.default_table_expiration_ms
  project_id                  = var.project_id
  location                    = "europe-west2"
  tables = [
    {
      table_id = "temp_table",
      schema   = file("sample_bq_schema.json"),
      time_partitioning = {
        type                     = "MONTH",
        field                    = null,
        require_partition_filter = false,
        expiration_ms            = null,
      },
      range_partitioning = null,
      expiration_time    = null,
      clustering         = ["fullVisitorId", "visitId"],
      labels = {
        env      = "dev"
        billable = "true"
        owner    = "joedoe"
      },
    }
  ]
}
