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

# Clone the lesson materials

This lesson calls several Kubernetes API Documents to create the EKS cluster.

These can be found in my lessons repo on Github: 
[https://github.com/berttejeda/bert.lessons.git](https://github.com/berttejeda/bert.lessons.git)

Let's perform a sparse clone to gather the lesson materials before we start:

<pre class='clickable-code'>
mkdir bert.lessons
cd bert.lessons
git init
git remote add -f origin https://github.com/berttejeda/bert.lessons.git
git config core.sparseCheckout true
echo 'crossplane/lesson-02/eks' >> .git/info/sparse-checkout
git pull origin main
cd crossplane/lesson-02/eks
clear
</pre>

# Set Your Kubernetes Context

1. Let's set our _KUBECONFIG_ environmental variable as before: `export KUBECONFIG=$(ls ~/.kube/*.yaml | tr '\n' ':')`
1. Switch to the Kubernetes context from the previous lesson: `kubectl config use-context kind-crossplane-demo`

# Create the requisite AWS Resources for our EKS cluster

1. Create the VPC and verify its state: `kubectl apply -f vpc/vpc.yaml`
1. Verify the state of the VPC resource: `kubectl get vpc`
1. Create the security groups for the EKS cluster and Node Groups: `kubectl apply -f security/securitygroup.yaml`
1. Verify that these resources are Synced and Ready: `kubectl get securitygroup`
1. Create the Internet and Nat gateway resources: `kubectl apply -f networking/gateway.yaml`
1. Verify that these resources are Synced and Ready:
    - `kubectl get internetgateway`
    - `kubectl get natgateway`
1. Create the IaM role and attach appropriate policies for our EKS cluster: `kubectl apply -f security/iam.yaml`
1. Verify Synced and Ready: `kubectl get role`
1. Create the subnet resources: `kubectl apply -f networking/subnet.yaml`
1. Verify Synced and Ready: `kubectl get subnet`
1. Create the eks control plane: `kubectl apply -f cluster/control-plane.yaml`
1. Verify Synced and Ready: `kubectl get cluster.eks.aws.crossplane.io/cp-demo-k8s-cluster`
1. Create the EKS worker node group: `kubectl apply -f cluster/workers.yaml`
1. Verify Synced and Ready: `kubectl get nodegroup`

At this point, the EKS cluster should in a _Creating_ state.

It can take up to 20 minutes or so for the cluster to be created.

That we utilized a Kubernetes-native approach to provisioning the above infrastructure is immensely powerful.

If you're a dev, you don't need to learn a new technology stack to gain insight and understanding on how
to provision the compute resources you need to deploy your workloads.


# Closing Notes

Here's a github gist for doing the above in Terraform: 
[https://gist.github.com/zparnold/dba28e5022e8c029919e0be3c38c64cc](https://gist.github.com/zparnold/dba28e5022e8c029919e0be3c38c64cc)

