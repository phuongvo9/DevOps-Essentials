# Admission Controllers 
## What is Admission controllers
An admission controller is a piece of code that intercepts requests to the Kubernetes API server prior to persistence of the object, but after the request is authenticated and authorized.

Admission controllers may be validating, mutating, or both.

Admission controllers limit requests to create, delete, modify objects. Admission controllers can not block requests to read

## Admission control phases 
In 1st phase, mutating admission controllers are run
In 2nd phase, validating admission controllers are run.

If any of the controllers in either phase reject the request, the entire request is rejected immediately and an error is returned to the end-use

