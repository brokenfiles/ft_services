#!/bin/sh

#check if minikube is not already start and the installations
if ! minikube status >/dev/null 2>&1
then
    printf "Starting minikube...\n"
    if ! minikube start --vm-driver=virtualbox --cpus 3 --disk-size=30000mb --memory=3000mb --bootstrapper=kubeadm
    then
        printf "Minikube cannot start !\n"
        exit 1
    fi
    minikube addons enable metrics-server
    minikube addons enable ingress
fi

IP_ADDRESS=$(minikube ip)
echo "$IP_ADDRESS" > srcs/wordpress/mnk_ip

eval $(minikube docker-env)
docker build -t my-nginx:1.11 srcs/nginx
docker build -t my-mysql:1.11  srcs/mysql
docker build -t my-ftps:1.6 srcs/ftps
docker build -t my-phpmyadmin:1.1 srcs/phpmyadmin
docker build -t my-wordpress:1.9 srcs/wordpress

#adding .yaml
kubectl apply -f srcs/ingress.yaml
kubectl apply -f srcs/nginx.yaml
kubectl apply -f srcs/ftps-deployment.yaml
kubectl apply -f srcs/mysql.yaml
kubectl apply -f srcs/phpmyadmin.yaml
kubectl apply -f srcs/kubernetes-dashboard.yaml
kubectl apply -f srcs/wordpress.yaml

rm -f srcs/wordpress/mnk_ip

printf "📦 minikube ip : %s\n" "$IP_ADDRESS"
while true; do
    read -p "Copy [$IP_ADDRESS] to your clipboard ? (y/n) " yn
    case $yn in
        [Yy]* ) echo "$IP_ADDRESS" | pbcopy; printf "%s copied to your clipboard.\n" "$IP_ADDRESS"; break;;
        * ) exit;;
    esac
done

