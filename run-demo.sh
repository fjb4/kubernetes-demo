#!/bin/bash

########################
# include the magic
########################
. demo-magic.sh

docker image rm registry.gke.jb-cloud.com/library/dotnetapp

kubectl config use-context docker-desktop

kubectl delete service dotnetapp-svc
kubectl delete pod dotnetapp-pod
kubectl delete replicaset dotnetapp-rep
kubectl delete deployment dotnetapp-dep

# hide the evidence
clear

# Run locally
pei "ls"
pe "dotnet run --project dotnet-app"
wait

#pe "open http://localhost:5000/"
#pe "open http://localhost:5000/stop"

rm -r dotnet-app/bin
rm -r dotnet-app/obj

# Run with Docker
clear
pe "bat Dockerfile"
pe "docker build --pull -t registry.gke.jb-cloud.com/library/dotnetapp ."
pe "docker image list | grep dotnetapp"
pe "docker run --rm -it -p 8000:80 registry.gke.jb-cloud.com/library/dotnetapp"
wait

#pe "open http://localhost:8000/"
#pe "open http://localhost:8000/stop"

# Kubernetes - kubectl
clear
pe "kubectl"
pe "kubectl config get-contexts"
#pei "kubectl cluster-info"
pe "kubectl get node -o wide"
pe "kubectl get all --all-namespaces"
wait

# Kubernetes - Services
clear
pe "bat 1-service.yaml"
pe "kubectl apply -f 1-service.yaml"
pei "kubectl get service dotnetapp-svc -w"

# Kubernetes - Pods
clear
pe "bat 2-pod.yaml"
pe "kubectl apply -f 2-pod.yaml"
pe "kubectl get pod dotnetapp-pod -w"
pe "kubectl logs dotnetapp-pod"
pe "kubectl delete pod dotnetapp-pod"

# Kubernetes - ReplicaSet
clear
pe "bat 3-replicaset.yaml"
pe "kubectl apply -f 3-replicaset.yaml"
pe "kubectl get all"
pe "kubectl scale --replicas=5 replicaset dotnetapp-rep"
pe "kubectl get all"
pe "kubectl delete replicaset dotnetapp-rep"

# Kubernetes - Deployments
clear
pe "bat 4-deployment.yaml"
pe "kubectl apply -f 4-deployment.yaml --record"
pe "kubectl get all"
pe "kubectl rollout history deployment dotnetapp-dep"
wait

clear
pe "bat 5-deployment.yaml"
pe "kubectl apply -f 5-deployment.yaml --record"
pe "kubectl rollout status deployment dotnetapp-dep"
pe "kubectl rollout undo deployment dotnetapp-dep"
pe "kubectl rollout history deployment dotnetapp-dep"
pe "kubectl delete deployment dotnetapp-dep"