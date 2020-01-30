# Installing on Cloud Providers

## Requirements

To install the helm chart you will need `kubectl` and `helm`.

**macOS**

```
brew install kubectl helm
```

**linux**

```
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

curl -LO https://get.helm.sh/helm-`curl -sSL https://github.com/kubernetes/helm/releases | sed -n '/Latest release<\/a>/,$p' | grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+' | head -1`-linux-amd64.tar.gz
tar xvzf ./helm-*-linux-amd64.tar.gz
chmod +x ./linux-amd64/helm
sudo mv ./linux-amd64/helm /usr/local/bin/helm
rm -r ./helm-*-linux-amd64.tar.gz ./linux-amd64/
```

**windows**

```
choco install kubernetes-cli kubernetes-helm
```

## Providers

Before we can install the RAPIDS helm chart we need to create a GPU enabled Kubernetes cluster on your preferred cloud provider.

See the following sections below for creating a cluster on AWS, Azure or GCP.

### AWS

#### Requirements

Install `awscli`.

```
pip install awscli --upgrade --user
```

Configure `awscli`.

```
$ aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-west-2
Default output format [None]: json
```

Install `eksctl`.

**macOS**

```
brew tap weaveworks/tap
brew install weaveworks/tap/eksctl
```

**linux**

```
curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
```

**windows**

```
chocolatey install -y eksctl aws-iam-authenticator
```

#### Create cluster

```
eksctl create cluster \
    --name rapids \
    --version 1.14 \
    --region us-west-2 \
    --nodegroup-name gpu-workers \
    --node-type p3.8xlarge \
    --nodes 1 \
    --nodes-min 1 \
    --nodes-max 4 \
    --node-volume-size 50 \
    --ssh-access \
    --ssh-public-key ~/.ssh/id_rsa.pub \
    --managed
```

Install GPU addon.

```
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/1.0.0-beta4/nvidia-device-plugin.yml
```

You can now continue to the [Helm](#Helm) section for instructions on installing the RAPIDS helm chart.

### Azure

#### Requirements

Install Azure CLI tool `az`.

**macOS**

```
brew install azure-cli
```

**linux**

```
curl -L https://aka.ms/InstallAzureCli | bash
```

**windows**

```
Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'
```

Configure `az`.

```
az login
```

Create a resource group if you don't already have one.

```
az group create --name myResourceGroup --location eastus
```

#### Create cluster

```
az aks create \
    --resource-group myResourceGroup \
    --name rapids \
    --node-vm-size Standard_NC12 \
    --node-count 2
```

Update your local `kubectl` config file.

```
az aks get-credentials --resource-group myResourceGroup --name rapids
```

Install GPU addon.

```
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/1.0.0-beta4/nvidia-device-plugin.yml
```

You can now continue to the [Helm](#Helm) section for instructions on installing the RAPIDS helm chart.

### GCP

#### Requirements

Install the Google Cloud CLI tool `gcloud`.

**macOS**

```
curl https://sdk.cloud.google.com | bash
```

**linux**

```
curl https://sdk.cloud.google.com | bash
```

**windows**

```
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")

& $env:Temp\GoogleCloudSDKInstaller.exe
```

Configure `gcloud`.

```
gcloud init
```

You may wish to change your default compute zone to somewhere else to avoid repeatedly typing it.

```
gcloud config set compute/zone europe-west4
```

**Note: You can run `gcloud compute accelerator-types list` to check which accelerators are available in which regions and node locations.**

#### Create cluster

```
gcloud container clusters create \
    rapids \
    --machine-type n1-standard-4 \
    --accelerator type=nvidia-tesla-v100,count=2 \
    --region europe-west4 \
    --node-locations europe-west4-a,europe-west4-b \
    --num-nodes 1 \
    --min-nodes 0 \
    --max-nodes 4 \
    --enable-autoscaling
```

Update your local `kubectl` config file.

```
gcloud container clusters get-credentials rapids
```

Install GPU addon.

```
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/container-engine-accelerators/master/nvidia-driver-installer/cos/daemonset-preloaded.yaml
```

You can now continue to the [Helm](#Helm) section for instructions on installing the RAPIDS helm chart.

## Helm

### Install RAPIDS helm repo

```
helm repo add rapidsai https://helm.rapids.ai
helm repo update
```

### Install helm chart

```
helm install rapidstest rapidsai/rapidsai
```

For detailed information on configuring your RAPIDS installation see the README.

## Accessing your cluster

```
$ kubectl get svc
NAME                 TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                       AGE
kubernetes           ClusterIP      10.100.0.1       <none>        443/TCP                       14m
rapidsai-jupyter     LoadBalancer   10.100.208.179   1.2.3.4       80:32332/TCP                  3m30s
rapidsai-scheduler   LoadBalancer   10.100.19.121    5.6.7.8       8786:31779/TCP,80:32011/TCP   3m30s
```

Visit the external IP of the `rapidsai-jupyter` service in your browser.

## Using your cluster
