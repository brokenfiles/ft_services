#!/bin/sh

docker build -t custom-nginx:1.11 ./srcs/nginx

#check if minikube is not already start and the installations
minikube start --vm-driver=virtualbox \
        --cpus 3 --disk-size=30000mb --memory=3000mb \
        --bootstrapper=kubeadm

#adding .yaml
kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/ingress.yaml

