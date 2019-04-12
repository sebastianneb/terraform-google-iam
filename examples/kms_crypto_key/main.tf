/**
 * Copyright 2018 Google LLC
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

locals {
  credentials_file_path = "${var.credentials_file_path}"
}

/******************************************
  Provider configuration
 *****************************************/
provider "google" {
  credentials = "${file(local.credentials_file_path)}"
  version     = "~> 1.20"
}

provider "google-beta" {
  credentials = "${file(local.credentials_file_path)}"
  version     = "~> 1.20"
}

/******************************************
  Module kms_crypto_key_iam_binding calling
 *****************************************/
module "kms_crypto_key_iam_binding" {
  source          = "../../"
  kms_crypto_keys = ["${var.kms_crypto_key_one}", "${var.kms_crypto_key_two}"]

  mode = "authoritative"

  bindings = {
    "roles/cloudkms.cryptoKeyEncrypter" = [
      "user:${var.user_email}",
      "group:${var.group_email}",
    ]

    "roles/cloudkms.cryptoKeyDecrypter" = [
      "user:${var.user_email}",
      "group:${var.group_email}",
    ]
  }
}