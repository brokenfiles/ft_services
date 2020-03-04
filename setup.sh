#!/bin/sh

#check if minikube is not already start and the installations
minikube start --vm-driver=virtualbox \
        --cpus 3 --disk-size=30000mb --memory=3000mb \
        --bootstrapper=kubeadm

MINIKUBE_IP=$(minikube ip)

eval $(minikube docker-env)
docker build -t custom-nginx:1.11 srcs/nginx

#adding .yaml
minikube addons enable ingress
kubectl apply -f srcs/ingress.yaml
kubectl apply -f srcs/nginx.yaml

printf "=> minikube ip = %s" $MINIKUBE_IP


