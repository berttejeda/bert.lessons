# Forward

Thank you for taking the time to start reading this educational material.

I hope this hands-on, interactive lesson can reduce the startup 
cost in your journey to learning [CrossPlane](crossplane.io).

# Lesson 01

This lesson will cover the following exercises:
- Initialize a local Kubernetes cluster using [kind](https://kind.sigs.k8s.io) 
- Install CrossPlane on a local cluster using [helm](https://helm.sh/)
- Connect the installation to an AWS account

# What is Kubernetes?

Kubernetes is a microservices architecture (MSA) platform for automating deployment, 
operations and scaling of containerized applications. 

It can run anywhere where Linux runs and supports on-premise, hybrid and public cloud deployments.

# What is CrossPlane?

<!---
From: Build your cloud infrastructure on Kubernetes with CrossPlane
https://www.padok.fr/en/blog/kubernetes-infrastructure-crossplane
-->
  
- CrossPlane is a free, open-source Kubernetes add-on that transforms your cluster into a universal control plane
- Was created by Upbound, and was first released in December of 2018
- It was accepted as an incubating project by the CNCF (Cloud Native Computing Foundation) in 2020

# Features

From the [website](crossplane.io):

- CrossPlane enables platform teams to assemble infrastructure from multiple vendors, 
  and expose higher level self-service APIs for application teams to consume, 
  without having to write any code.
- CrossPlane extends your Kubernetes cluster to support orchestrating any infrastructure or managed services
- Can be installed into any Kubernetes cluster to get started
- Supports most major cloud providers and covers typical service deployments<br />
  As such, it offers an alternative to Terraform, CDK, and Pulumi

# Why is this approach to infrastructure management significant?

I mentioned _self-service_ in the previous slide. That's the key here.

- From a deployment standpoint, Kubernetes already breaks down barriers to entry for Developers
- To get an app deployed, developers need only describe their workloads using 
  Kubernetes API Documents, which are expressed in _yaml_ syntax
- CrossPlane extends this self-service approach a layer above that -- to the infrastructure itself
- It helps Developers claim cloud resources through expression of Kubernetes API Documents in the same way
  they do for their workloads
- The infrastructure is defined declaratively without writing any code and without revealing the 
  underlying infrastructure of the specific vendor
- Because CrossPlane exposes administration of higher-level infrastructure in a Kubernetes-native manner,
  it allows us to easily design, manage, distribute, and consume these infrastructure abstractions 
  within the existing ecosystem of Kubernetes add-ons, plugins, and integrations


Let's put what I just said into practice

# Create a local Kubernetes cluster

Since CrossPlane is a Kubernets add-on, we'll need a Kubernetes cluster on which to install it.

For the purposes of this introduction, we'll utilize [kind](https://kind.sigs.k8s.io) to initialize our demo cluster.

For those of you not familiar with the tool, it's used for running local Kubernetes clusters using Docker containers as worker _nodes_.

I've already installed version v0.14.0 of the tool: `kind version`

The syntax for creating a Kubernetes cluster using the _kind_ command is quite simple.

We can run `kind create cluster --help` to get more info, but you can create a cluster by just running `kind create cluster`.

For our demonstration, we'll create a Kubernetes cluster named _crossplane-demo_ with some customizations

<pre class='clickable-code'>
echo -e """
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30001
    hostPort: 30001
  - containerPort: 30002
    hostPort: 30002
- role: worker
"""  | kind create cluster --name crossplane-demo --config=-
</pre>

Next, we'll initialize our Kubernetes config and context.

You can retrieve your cluster's kubeconfig via the command `kind --name crossplane-demo get kubeconfig`

We'll pipe that to our kubeconfig file using the _tee_ command:<br />
`kind --name crossplane-demo get kubeconfig | tee ~/.kube/crossplane.yaml`

<!--kubectl config get-contexts-->
We'll then set our _KUBECONFIG_ environmental variable: `export KUBECONFIG=$(ls ~/.kube/*.yaml | tr '\n' ':')`
and finally set our active Kubernetes context: `kubectl config use-context kind-crossplane-demo`

Next, we install CrossPlane.

# Install CrossPlane

- Create the crossplane namespace: `kubectl create namespace crossplane-system`
- We'll install its components using [helm](https://helm.sh/):
    1. First, add the crossplane helm repo: `helm repo add crossplane-stable https://charts.crossplane.io/stable`
    1. Sync our local helm repos with their upstream `helm repo update`
    1. We install crossplane:<br />
       `helm install crossplane --namespace crossplane-system crossplane-stable/crossplane`
    1. Lastly, we check the components are up and healthy: `kubectl get all -n crossplane-system`

Now that we have CrossPlane installed, let's connect it to our AWS infrastructure.

# Install the AWS Provider

For CrossPlane to manage our AWS Infrastructure, we must first 
install the [AWS Provider](https://github.com/crossplane-contrib/provider-aws). 

A CrossPlane provider ships with CRDs ( Custom Resources Definitions ) required to create resources on the AWS cloud. 

1. Create the provider Kubernetes API Document:<br />
<pre class='clickable-code'>
echo -e """apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: aws-provider
spec:
  package: crossplane/provider-aws:alpha""" > provider.yaml
</pre>
1. Apply the document: `kubectl apply -f provider.yaml`
1. Wait for the Provider to become healthy: `kubectl get provider.pkg --watch`

Now that the Provider is in a healthy state, we're ready to connect CrossPlane to our AWS infrastructure.

# Connect CrossPlane to our AWS Infrastructure

To connect CrossPlane to our AWS Infrastructure, we must create a _ProviderConfig_ definition. 

1. I've already configured my AWS credentials using `aws configure` beforehand, so I'll now
generate the Provider configuration file with my AWS Credentials, as follows:<br />
<pre class='clickable-code'>
echo -e """
[default]
aws_access_key_id = $(aws configure get aws_access_key_id --profile default)
aws_secret_access_key = $(aws configure get aws_secret_access_key --profile default)
""" > creds.conf
</pre>
1. Next, we create a Kubernetes secret with the configuration file we just generated:<br />
`kubectl create secret generic aws-secret-creds -n crossplane-system --from-file=creds=./creds.conf`
1. We then create the Provider config for our AWS account:<br />
<pre class='clickable-code'>
echo -e """apiVersion: aws.crossplane.io/v1beta1
kind: ProviderConfig
metadata:
  name: awsconfig
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: aws-secret-creds
      key: creds""" > provider-config.yaml
</pre>
1. Now apply our provider config: `kubectl apply -f provider-config.yaml`
1. Because we're ultimately working with Kubernetes-native resources,<br />
   we can verify the provider's pod instance:<br />
   `kubectl -n crossplane-system get pods -l pkg.crossplane.io/provider=provider-aws`<br />
   Everything looks good so far

With CrossPlane installed and connected to our AWS infrastructure, we're ready to launch some nukes.

Let's move onto lesson 02.