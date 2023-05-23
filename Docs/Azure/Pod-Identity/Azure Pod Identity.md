# What is Azure pod-managed identities?

Azure Active Directory (Azure AD) pod-managed identities use Kubernetes primitives to associate managed identities for Azure resources and identities in Azure AD with pods


# What is the relationship between Azure and Kubernetes? (types of identities)

# Conversation between IMDS transactions to OIDC

# What steps needed to migrate from Pod Identities to Workload Identities?
1. Enable OIDC issuer
2. Create a federated credential, which is at the heart of workload identity, link between the service account used by our workload, and the user-assigned managed identity
3. Update K8S service account with annotations and labels