# Create nginx POD
kubectl run nginx-pod --image=nginx

# we can get away with just the kubectl run command without having to create a YAML file at all

kubectl run nginx --image=nginx --dry-run=client -o yaml