#!/bin/sh

#check if minikube is not already start and the installations
minikube start --vm-driver=virtualbox \
        --cpus 3 --disk-size=30000mb --memory=3000mb \
        --bootstrapper=kubeadm

MINIKUBE_IP=$(minikube ip)

eval $(minikube docker-env)
docker build -t custom-nginx:1.11 srcs/nginx
docker build -t custom-mysql:1.11  srcs/mysql
docker build -t custom-ftps:1.6 srcs/ftps
docker build -t custom-phpmyadmin:1.1 srcs/phpmyadmin
docker build -t custom-wordpress:1.9 srcs/wordpress

#enable addons
minikube addons enable ingress

#adding .yaml
kubectl apply -k srcs
#kubectl apply -f srcs/ingress.yaml
#kubectl apply -f srcs/nginx.yaml
#kubectl apply -f srcs/ftps-deployment.yaml
#kubectl apply -f srcs/mysql.yaml
#kubectl apply -f srcs/kubernetes-dashboard.yaml

printf "📦 minikube ip : %s (copied to your clipboard)\n" "$MINIKUBE_IP"
echo "$MINIKUBE_IP" | pbcopy


