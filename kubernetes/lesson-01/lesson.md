# Forward

Thank you for taking the time to start reading this educational material.

I hope this hands-on, interactive lesson can reduce the startup 
cost in your journey to learning [Kubernetes](https://kubernetes.io/).

# Lesson 01

This lesson will cover the following exercises:

- Initialize a local Kubernetes cluster using [kind](https://kind.sigs.k8s.io) 
- Installing [helm](https://helm.sh/)

# What is Kubernetes?

Kubernetes is a microservices architecture (MSA) platform for automating deployment, 
operations and scaling of containerized applications. 

It can run anywhere where Linux runs and supports on-premise, hybrid and public cloud deployments.

# Install the kind binary

We'll be using [kind](https://kind.sigs.k8s.io) to initialize our demo cluster.

Below are several means of installing the `kind` binary

## Install on Linux

<pre class='clickable-code'>
export KIND_VERSION=v0.14.0
curl -fLo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-linux-amd64" \
&& chmod +x ./kind \
&& mv ./kind /usr/local/bin/kind
</pre>

## Install on OSX (ARM)

If you have [homebrew](https://docs.brew.sh/) installed, you can simply run `brew install kind`.

Otherwise you download via `curl`:

<pre class='clickable-code'>
export KIND_VERSION=v0.14.0 
curl -fLo ./kind "https://github.com/kubernetes-sigs/kind/releases/download/${KIND_VERSION}/kind-darwin-arm64" \
&& chmod +x ./kind \
&& mv ./kind /usr/local/bin/kind
</pre>

## Install on Windows

On Windows, we can use [chocolatey](https://chocolatey.org/) to install: `choco install kind`

## Manually download binary

You can manually download the kind binary from [https://github.com/kubernetes-sigs/kind/releases](https://github.com/kubernetes-sigs/kind/releases) to get started

# Create a local Kubernetes cluster

For those of you not familiar with the tool, it's used for running local Kubernetes clusters using Docker containers as worker _nodes_.

I've already installed version v0.14.0 of the tool: `kind version`

The syntax for creating a Kubernetes cluster using the _kind_ command is quite simple.

We can run `kind create cluster --help` to get more info, but you can create a cluster by just running `kind create cluster`.

For our demonstration, we'll create a Kubernetes cluster named _k8s-demo_ with some customizations

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
"""  | kind create cluster --name k8s-demo --config=-
</pre>

Next, we'll initialize our Kubernetes config and context.

You can retrieve your cluster's kubeconfig via the command `kind --name k8s-demo get kubeconfig`

We'll pipe that to our kubeconfig file using the _tee_ command:<br />
`kind --name k8s-demo get kubeconfig | tee ~/.kube/crossplane.yaml`

<!--kubectl config get-contexts-->
We'll then set our _KUBECONFIG_ environmental variable: `export KUBECONFIG=$(ls ~/.kube/*.yaml | tr '\n' ':')`
and finally set our active Kubernetes context: `kubectl config use-context kind-k8s-demo`

You should now be ready to start playing with Kubernetes.

Let's install `helm`.

# Install the helm binary

Below are several means of installing the `helm` binary

## Install on Linux

<pre class='clickable-code'>
export HELM_VERSION=v3.9.2
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 \
&& chmod +x get_helm.sh && DESIRED_VERSION=$HELM_VERSION ./get_helm.sh
</pre>

## Install on OSX (ARM)

If you have [homebrew](https://docs.brew.sh/) installed, you can simply run `brew install helm`.

## Install on Windows

On Windows, we can use [chocolatey](https://chocolatey.org/) to install: `choco install helm`

## Manually download binary

You can manually download the kind binary from [https://github.com/helm/helm/releases](https://github.com/helm/helm/releases) to get started

# End

This concludes the Lab 01.