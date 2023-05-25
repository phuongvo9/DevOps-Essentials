# What is Azure pod-managed identities?

Azure Active Directory (Azure AD) pod-managed identities use Kubernetes primitives to associate managed identities for Azure resources and identities in Azure AD with pods


# What is the relationship between Azure and Kubernetes? (types of identities)

# Conversation between IMDS transactions to OIDC
IMDS (Instance Metadata Service) is a REST API that’s available at a well-known, non-routable IP address (169.254.169.254). You can only access it from within the VM. Communication between the VM and IMDS never leaves the host. On the other hand, OpenID Connect (OIDC) is an authentication protocol based on the OAuth2 protocol (which is used for authorization). OIDC uses the standardized message flows from OAuth2 to provide identity services


# What version Azure Identity was installed?
.NET
Java

Check on dependencies


# Dependencies to install Azure workload?
AKS supports 1.22 ++
AZ CLIS version 2.47.0 or later
`az --version`

# What steps needed to migrate from Pod Identities to Workload Identities?
1. Enable OIDC issuer
2. Create a federated credential, which is at the heart of workload identity, link between the service account used by our workload, and the user-assigned managed identity
3. Update K8S service account with annotations and labels


# What is Microsoft Authentication Library (MSAL) used for?
ghcr.io/azure/azure-workload-identity/msal-java	
ghcr.io/azure/azure-workload-identity/msal-net	




# Deploy the workload 
# How does Azure Workload identity work?




# Reference

https://github.com/MicrosoftDocs/azure-docs/blob/main/articles/aks/workload-identity-migrate-from-pod-identity.md
