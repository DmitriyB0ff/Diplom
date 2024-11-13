#!/bin/bash

#Скачиваем и устанавливаем CLI YC (неинтерактивный режим)
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh |     bash -s -- -i ./yc -n
#Переходим в каталог ./yc/bin
cd ./yc/bin/
#Задаём конфигурацию профиля sa
echo "TOKEN"
./yc config set token ${YC_SA_KEY} #service-account-key ${YC_SA_KEY}
echo "CLOUD"
./yc config set cloud-id ${YC_CLOUD_ID}
./yc config set folder-id ${YC_FOLDER_ID}
#Проверяем видимость кубекластера в YC
./yc managed-kubernetes cluster list
#Конфигурируем kubeconfig
echo "YC_CLUSTER_ID"
./yc managed-kubernetes cluster get-credentials ${YC_CLUSTER_ID} --external
#Добавляем manespace в kubeconfig
sed -i '9i\    namespace: yc-managed-k8s' /root/.kube/config