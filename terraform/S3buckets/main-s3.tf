#Чувствительные данные спрятаны за переменные исключительно ради наглядности. Сам конфиг запускался вручную и не встроен ни в один пайплайн
############################################################################
# Данные YC test
############################################################################

locals {
  cloud_id    = var.yc_cloud_id
  folder_id   = var.yc_folder_id
  k8s_version = "1.22"
  sa_name     = "storageaccount"
}

############################################################################
# Указание на провайдера
############################################################################

terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.87.0"

  ############################################################################
  # Хранение файла с состоянием в бакете S3
  ############################################################################

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket     = "momo-terraform"
    region     = "ru-central1"
    key        = "tf_state_s3/terraform.tfstate"
    access_key = "YCAJE1XM6EdNeLedON1VvEGmm"                #var.access_key
    secret_key = "YCMyZoxhThNDukInp66hArJ7G7AWDQUgWKR_C7-p" #var.secret_key

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }

}
############################################################################
# Токен для работы с облаком
############################################################################

provider "yandex" {
  token     = var.yc_iam_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.zone
}

############################################################################
# Создание необходимых сервисных аккаунтов
############################################################################

resource "yandex_iam_service_account" "storageaccount" {
  name        = "storageaccount"
  description = "S3 zonal service account"
}

############################################################################
# Назначение ролей созданным сервисным аккаунтам
############################################################################

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.storageaccount.id}"
}

############################################################################
# Статический ключ
############################################################################

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.storageaccount.id
  description        = "static access key for object storage"
}

############################################################################
# Создание бакетов (для состояний terraform и статики сайта momo)
############################################################################

resource "yandex_storage_bucket" "momo-terraform" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "momo-terraform"
}

resource "yandex_storage_bucket" "momo-pictures" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "momo-pictures"
  anonymous_access_flags {
    read = true
    list = false
  }
}
