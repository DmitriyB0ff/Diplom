variable "yc_iam_token" {
  description = "Yandex Cloud security OAuth token"
}

variable "yc_folder_id" {
  description = "Yandex Cloud Folder ID where resources will be created"
}

variable "yc_cloud_id" {
  description = "Yandex Cloud ID where resources will be created"
}

variable "zone" {
  description = "Yandex Cloud default Zone for provisoned resources"
  default     = "ru-central1-a"
}
variable "instance_zone" {
  description = "Yandex zone"
  default     = "ru-central1-a"
}

variable "access_key" {
  description = "access_key"
}

variable "secret_key" {
  description = "Yandex zone"
}
