
gcloud config set compute/zone us-central1-a

gsutil -m cp -r gs://spls/gsp053/orchestrate-with-kubernetes .
cd orchestrate-with-kubernetes/kubernetes

gcloud container clusters create bootcamp --num-nodes 5 --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"



kubectl explain deployment

kubectl explain deployment --recursive

kubectl explain deployment.metadata.name

vi deployments/auth.yaml
i

...
containers:
- name: auth
  image: "kelseyhightower/auth:1.0.0"
...

#<Esc>:wq

cat deployments/auth.yaml
kubectl create -f deployments/auth.yaml
kubectl get deployments
#erify that a ReplicaSet was created for our Deployment
kubectl get replicasets


kubectl get pods
kubectl create -f services/auth.yaml
kubectl create -f deployments/hello.yaml
kubectl create -f services/hello.yaml
kubectl create secret generic tls-certs --from-file tls/
kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf
kubectl create -f deployments/frontend.yaml
kubectl create -f services/frontend.yaml

kubectl get services frontend

curl -ks https://<EXTERNAL-IP>

curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`

########
### Scale a deployment
###


kubectl explain deployment.spec.replicas
kubectl scale deployment hello --replicas=5
kubectl get pods | grep hello- | wc -l

# Scale back
kubectl scale deployment hello --replicas=3
# Verify pods
kubectl get pods | grep hello- | wc -l

###Trigger rolling update


kubectl edit deployment hello
# vi
# ... Change version from 1.0.0 to 2.0.0
# containers:
#   image: kelseyhightower/hello:2.0.0
# ...

kubectl get replicaset

# See rollout histroy
kubectl rollout history deployment/hello

# If you detect problems with a running rollout, pause it to stop the update
kubectl rollout pause deployment/hello
kubectl rollout status deployment/hello
#veryfy on the pods directly
kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'


# Resume a rolling update

kubectl rollout resume deployment/hello
# See running status
kubectl rollout status deployment/hello


####
## Rollback an update


kubectl rollout undo deployment/hello
# verify roll back in history
kubectl rollout history deployment/hello

#verify that all the Pods have rolled back to their previous versions:
kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'




kubectl get pods -o jsonpath --template='{range .items[*]}{.metadata.name}{"\t"}{"\t"}{.spec.containers[0].image}{"\n"}{end}'


#####################
# Create a canary deployment

######################
#A canary deployment consists of a separate deployment with your new version `
#and a service that targets both your normal, stable deployment as well as your canary deployment.

# Create a new canary deployment for new version

cat deployments/hello-canary.yaml

kubectl create -f deployments/hello-canary.yaml

kubectl get deployments


###
### Blue-green deployments
###

kubectl apply -f services/hello-blue.yaml


# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: hello-green
# spec:
#   replicas: 3
#   selector:
#     matchLabels:
#       app: hello
#   template:
#     metadata:
#       labels:
#         app: hello
#         track: stable
#         version: 2.0.0
#     spec:
#       containers:
#         - name: hello
#           image: kelseyhightower/hello:2.0.0
#           ports:
#             - name: http
#               containerPort: 80
#             - name: health
#               containerPort: 81
#           resources:
#             limits:
#               cpu: 0.2
#               memory: 10Mi
#           livenessProbe:
#             httpGet:
#               path: /healthz
#               port: 81
#               scheme: HTTP
#             initialDelaySeconds: 5
#             periodSeconds: 15
#             timeoutSeconds: 5
#           readinessProbe:
#             httpGet:
#               path: /readiness
#               port: 81
#               scheme: HTTP
#             initialDelaySeconds: 5
#             timeoutSeconds: 1

kubectl create -f deployments/hello-green.yaml

curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

kubectl apply -f services/hello-green.yaml

curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version

###
### Blue-green Rollback
###



kubectl apply -f services/hello-blue.yaml
curl -ks https://`kubectl get svc frontend -o=jsonpath="{.status.loadBalancer.ingress[0].ip}"`/version







