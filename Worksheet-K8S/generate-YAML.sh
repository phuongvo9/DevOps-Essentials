# Create nginx POD
kubectl run nginx-pod --image=nginx

    # -- we can get away with just the kubectl run command without having to create a YAML file at all

# Generate POD manifest yaml without creaing a pod
kubectl run nginx --image=nginx --dry-run=client -o yaml


# Create deployment
kubectl create deployment nginx --image=nginx
kubectl get deployment


# Generate deployment YAML (-o yaml) - Do not create it (--dry-run=client)
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml
# Generate deployment YAML to file (-o yaml) - Do not create it (--dry-run=client)
kubectl create deployment nginx --image=nginx --dry-run=client -o yaml > my-deployment.yaml
