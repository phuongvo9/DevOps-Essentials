
########################
# Installing Istio CLI #
########################


###############################
# Creating Kubernetes Cluster #
###############################
# Ref
# Docker for Desktop: https://gist.github.com/33fd661da626a167687ecb4267700588
# minikube: https://gist.github.com/e7ad0cc633831147d2dbcd4fe2a97a74
# GKE: https://gist.github.com/a260c0812459a57b46b9ea807a26173e
# EKS: https://gist.github.com/073edd549bc0c4d9bda6b4b7bd6bed99
# AKS: https://gist.github.com/c288e9a8dd45ce855d477d1780d2d2e1

####################
# Installing Istio #
####################

# NOTE: Make sure that you install `istioctl` v1.5+.
# NOTE: If you already have `istioctl`, make sure that it is updated if it's older than v1.5.

istioctl profile list

istioctl profile dump demo

istioctl manifest install \
    --set profile=demo

kubectl get crds | grep 'istio.io'

kubectl --namespace istio-system \
    get services

# Confirm that `EXTERNAL-IP` of `istio-ingressgateway` is not `pending`, unless using minikube

kubectl --namespace istio-system \
    get pods

############################
# Manual Sidecar Injection #
############################

git clone \
    https://github.com/vfarcic/k8s-specs.git

cd k8s-specs

git pull 

cat istio/alpine.yml

istioctl kube-inject \
    --filename istio/alpine.yml

istioctl kube-inject \
    --filename istio/alpine.yml \
    | kubectl apply --filename -

kubectl get pods

kubectl describe pod \
    --selector app=alpine

kubectl delete \
    --filename istio/alpine.yml

###############################
# Automatic Sidecar Injection #
###############################

kubectl apply \
    --filename istio/alpine.yml

kubectl get pods

kubectl label namespace default \
    istio-injection=enabled

kubectl describe namespace default

kubectl rollout restart \
    deployment alpine

kubectl get pods

kubectl describe pod \
    --selector app=alpine

kubectl label namespace default \
    istio-injection-

kubectl rollout restart \
    deployment alpine

kubectl get pods

kubectl delete \
    --filename istio/alpine.yml

###############
# Cleaning Up #
###############

istioctl manifest generate \
    --set profile=demo

istioctl manifest generate \
    --set profile=demo \
    | kubectl delete -f -

cd ..

# Destroy the cluster (optional)