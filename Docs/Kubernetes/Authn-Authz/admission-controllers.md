# Admission Controllers 
## What is Admission controllers
Kubernetes admission controllers are a way to intercept and modify requests to the Kubernetes API server before they are persisted to etcd. 
An admission controller is a piece of code that intercepts requests to the Kubernetes API server prior to persistence of the object, but after the request is authenticated and authorized.

Admission controllers may be validating, mutating, or both.

Admission controllers limit requests to create, delete, modify objects. Admission controllers can not block requests to read

## Admission control phases 
In 1st phase, mutating admission controllers are run
In 2nd phase, validating admission controllers are run.

If any of the controllers in either phase reject the request, the entire request is rejected immediately and an error is returned to the end-use

`MutatingWebhookConfiguration` and `ValidatingWebhookConfiguration` are two types of admission controllers that enable you to modify or validate resources as they are created or updated.

### MutatingWebhookConfiguration
`MutatingWebhookConfiguration` is an admission controller that modifies resources as they are created or updated. When a request is received by the Kubernetes API server, it is sent to the MutatingWebhookConfiguration admission controller, which invokes a webhook to modify the request. The modified request is then sent back to the Kubernetes API server and persisted to etcd.

Here's an example of a MutatingWebhookConfiguration that appends a label to all newly created or updated Pods:

```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: MutatingWebhookConfiguration
metadata:
  name: pod-labeler
webhooks:
- name: label-pods.jackvo9.medium
  clientConfig:
    service:
      name: pod-labeler-svc
      namespace: kube-system
      path: /label-pods
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - v1
    operations:
    - CREATE
    - UPDATE
    resources:
    - pods
  namespaceSelector:
    matchLabels:
      app: pod-labeler
  sideEffects: None
  timeoutSeconds: 5
  admissionReviewVersions: ["v1beta1", "v1"]

```
In this example, the MutatingWebhookConfiguration applies to newly created or updated Pods in the default namespace, and appends a label ```jackvo9.medium/labelled: "true" ``` to the Pod.

### ValidatingWebhookConfiguration:
ValidatingWebhookConfiguration is an admission controller that validates resources as they are created or updated. When a request is received by the Kubernetes API server, it is sent to the ValidatingWebhookConfiguration admission controller, which invokes a webhook to validate the request. The webhook can either allow or deny the request based on the validation results.

Here's an example of a ValidatingWebhookConfiguration that checks if Pods have a label named "app":
```yaml
apiVersion: admissionregistration.k8s.io/v1
kind: ValidatingWebhookConfiguration
metadata:
  name: pod-validator
webhooks:
- name: validate-pods.jackvo9.medium
  clientConfig:
    service:
      name: pod-validator-svc
      namespace: kube-system
      path: /validate-pods
  rules:
  - apiGroups:
    - ""
    apiVersions:
    - v1
    operations:
    - CREATE
    - UPDATE
    resources:
    - pods
  namespaceSelector:
    matchLabels:
      app: pod-validator
  sideEffects: None
  timeoutSeconds: 5
  admissionReviewVersions: ["v1beta1", "v1"]
  failurePolicy: Fail
  namespaceConfig:
    namespaceSelector:
      matchLabels:
        app: pod-validator
    admissionReviewLabels:
    - pod-validator
  matchPolicy: Exact
  objectSelector:
    matchLabels:
      app: pod-validator
  rules:
  - apiGroups: [""]
    apiVersions: ["v1"]
    operations: ["CREATE", "UPDATE"]
    resources: ["pods"]
  sideEffects: None
  timeoutSeconds: 5
  matchPolicy: Equivalent
  failurePolicy: Ignore
  namespaceSelector:
    matchLabels:
      app: pod-validator
  objectSelector:
    matchLabels:
      app: pod-validator
```

In this example, the `ValidatingWebhookConfiguration` applies to newly created or updated Pods in the default namespace