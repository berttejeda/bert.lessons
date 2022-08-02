# Forward

Thank you for taking the time to start reading this educational material.

I hope this hands-on, interactive lesson can reduce the startup 
cost in your journey to learning [CrossPlane](crossplane.io).

# Lesson 02

In the previous lesson we:

- Initialized a local Kubernetes cluster using [kind](https://kind.sigs.k8s.io) 
- Installed CrossPlane on the cluster using [helm](https://helm.sh/)
- Connected the installation to an AWS account

This lesson will cover the following exercises:

- Install an EKS cluster using Crossplane, which entails:
    - Creating Kubernetes API Documents for:
        - VPC
        - IAM Roles
        - Security Groups
        - VPC Internet Gateway
        - VPC NAT Gateway
        - Route Table
        - Subnet
        - Cluster
        - EKS Node Group

# Set Your Kubernetes Context

1. Let's set our _KUBECONFIG_ environmental variable as before: `export KUBECONFIG=$(ls ~/.kube/*.yaml | tr '\n' ':')`
1. Switch to the Kubernetes context from the previous lesson: `kubectl config use-context kind-crossplane-demo`

# Create the requisite AWS Resources for our EKS cluster

1. Create the VPC: `kubectl apply -f vpc `


