#!/bin/bash

#
# CONFIGURATION
#
MINIKUBE_LOCATION="docker"
INFORMATION="\033[01;33m"
SUCCESS="\033[1;32m"
ERROR="\033[1;31m"
RESET="\033[0;0m"

# Passwords:
# SSH : admin:admin
# ftps : user:pass
# wordpress : admin:pass
# grafana : admin:password
# phpmyadmin : wp_admin:pass

#
# Fonction qui prend deux paramètres, la couleur et le préfixe,
# puis le message
#
print_message() {
  NOW=$(date +%H:%M:%S)
  printf "$1%s ➜ $2$RESET\n" $NOW
}

redo_service()
{
  print_message $INFORMATION "Restarting $1..."
  kubectl delete deploy $1-deployment
  kubectl delete service $1-service
  eval "$(minikube docker-env)"
  docker rmi -f $1
  docker build -t $1 srcs/containers/$1/.
  kubectl apply -f srcs/manifests/$1.yaml
  print_message $SUCCESS "Restarted $1"
  print_message $SUCCESS "Ip address : $(minikube ip)"
}

clean_pods() {
  print_message $INFORMATION "Cleaning pods..."
  # delete all pods
  kubectl delete --all pods --namespace=default
  # deete all deployments
  kubectl delete --all deployments --namespace=default
  # delete all services
  kubectl delete --all services --namespace=default
  print_message $SUCCESS "Pods cleaned."
}

clean_volumes() {
  print_message $INFORMATION "Cleaning volumes..."
  # delete all pvc
  kubectl delete --all pvc --namespace=default
  # delete all pv
  kubectl delete --all pv --namespace=default
  print_message $SUCCESS "Volumes cleaned."
}

minikube_reset_vbox_dhcp_leases() {
  # # Reset Virtualbox DHCP Lease Info
  print_message $INFORMATION "Resetting Virtualbox DHCP Lease Info..."
  kill -9 $(ps aux |grep -i "vboxsvc\|vboxnetdhcp" | awk '{print $2}') 2>/dev/null

  if [[ -f ~/Library/VirtualBox/HostInterfaceNetworking-vboxnet0-Dhcpd.leases ]] ; then
    rm  ~/Library/VirtualBox/HostInterfaceNetworking-vboxnet0-Dhcpd.leases
  fi
  exit 0
}

help() {
  echo "    -clean        Nettoyer Minikube (enlève les pods)
    -restart      Redémarre minikube (peut prendre quelques minutes)
    --reset-ip    Remets l'adresse ip de minikube à zéro
    --help        Affiche la page d'aide "
}

for i in 0 $#
do
  if [ "$i" = "0" ]; then
    continue
  fi
  case "${!i}" in
    "-clean")
      clean_pods
    ;;
    "--clean-volumes")
      clean_volumes
    ;;
    "-restart")
      clean_pods
      minikube delete
    ;;
    "--reset-ip")
      minikube_reset_vbox_dhcp_leases
    ;;
    "-stop")
      exit 0
    ;;
    "-nginx")
      redo_service nginx
      exit 0
    ;;
    "-ftps")
      redo_service ftps
      exit 0
    ;;
    "-grafana")
      redo_service grafana
      exit 0
    ;;
    "-influxdb")
      redo_service influxdb
      exit 0
    ;;
    "-mysql")
      redo_service mysql
      exit 0
    ;;
    "-phpmyadmin")
      redo_service phpmyadmin
      exit 0
    ;;
    "-telegraf")
      redo_service telegraf
      exit 0
    ;;
    "-wordpress")
      redo_service wordpress
      exit 0
    ;;
    *)
      help
    ;;
  esac
done

echo "\033[01;33m
███████ ████████      ███████ ███████ ██████  ██    ██ ██  ██████ ███████ ███████ 
██         ██         ██      ██      ██   ██ ██    ██ ██ ██      ██      ██      
█████      ██         ███████ █████   ██████  ██    ██ ██ ██      █████   ███████ 
██         ██              ██ ██      ██   ██  ██  ██  ██ ██      ██           ██ 
██         ██ ███████ ███████ ███████ ██   ██   ████   ██  ██████ ███████ ███████    
                                                                    (by llaurent)       
                                                                                                                                    
\033[0;0m"


#
# On lance minikube seulement si il n'est pas lancé
#
if ! minikube status >/dev/null 2>&1
then
    print_message $INFORMATION "Trying to start Minikube..."
    if ! minikube start --vm-driver=$MINIKUBE_LOCATION --extra-config=apiserver.service-node-port-range=1-35000 # for linux
    then
        print_message $ERROR "Minikube cannot start !"
        exit 1
    fi
    print_message $SUCCESS "Minikube started successfully."
    print_message $INFORMATION "Adding addons to minikube..."
    # on ajoute les addons nécessaires au projet
    minikube addons enable ingress
    minikube addons enable metrics-server
    print_message $SUCCESS "Addons addedd successfully."
fi

print_message $INFORMATION "Trying to get minikube ip address."
# on récupère l'adresse ip de minikube afin de régler le problème du wordpress
IP_ADDRESS=$(minikube ip)
echo "$IP_ADDRESS" > srcs/containers/mysql/mnk_ip
echo "$IP_ADDRESS" > srcs/containers/ftps/mnk_ip
print_message $SUCCESS "Minikube IP ADDRESS : $IP_ADDRESS"

#replace ip
sed 's/REPLACE_IP/'"$IP_ADDRESS"'/g' srcs/manifests/telegraf.yaml > srcs/manifests/telegraf_ip.yaml
echo "UPDATE data_source SET url = 'http://$IP_ADDRESS:8086'" | sqlite3 srcs/containers/grafana/grafana.db

print_message $INFORMATION "Trying to build docker images..."
# on build toutes les images via docker dans l'environnement minikube
eval "$(minikube docker-env)"
docker build -t nginx srcs/containers/nginx
docker build -t mysql srcs/containers/mysql
docker build -t phpmyadmin srcs/containers/phpmyadmin
docker build -t wordpress srcs/containers/wordpress
docker build -t influx srcs/containers/influxdb
docker build -t grafana srcs/containers/grafana
docker build -t ftps srcs/containers/ftps
docker build -t telegraf srcs/containers/telegraf
print_message $SUCCESS "Docker images are built."

# adding YAML files to link docker images to kubectl and minikube
print_message $INFORMATION "Tring to add .yaml to minikube"
kubectl apply -f srcs/manifests/nginx.yaml
kubectl apply -f srcs/manifests/ingress.yaml # ajout de l'ingress
kubectl apply -f srcs/manifests/mysql.yaml
kubectl apply -f srcs/manifests/phpmyadmin.yaml
kubectl apply -f srcs/manifests/wordpress.yaml
kubectl apply -f srcs/manifests/influxdb.yaml
kubectl apply -f srcs/manifests/grafana.yaml
kubectl apply -f srcs/manifests/ftps.yaml
kubectl apply -f srcs/manifests/telegraf_ip.yaml
print_message $SUCCESS "YAML files added to minikube."

print_message $SUCCESS "Everything went well."

print_message $INFORMATION "Waiting for the site to be up."

until $(curl --output /dev/null --silent --head --fail http://$IP_ADDRESS/); do
	printf "."
	sleep 0.5
done;

printf "\n"

print_message $SUCCESS "Ip address : $IP_ADDRESS"

#while true; do
#    read -p "Copy [$IP_ADDRESS] to your clipboard ? (y/n) " yn
#    case $yn in
#        [Yy]* ) echo "$IP_ADDRESS" | pbcopy; printf "%s copied to your clipboard.\n" "$IP_ADDRESS"; break;;
#        * ) exit;;
#    esac
#done
