# ACM Workshop - Preparation Steps

## What you need
* A GCP project where you can run GKE, ACM and, if you want to manage non GKE clusters, enable Anthos
* A main user account with project owner role on the project 
* A Github account
* 2 additional Google accounts that will be used as the 'application deployment' teams with the 'Kubernetes Engine Cluster Viewer' role on the project, the 2nd account should also have a separate Github account to test the Pull Request workflow
* (If you want to manage non GKE clusters) an external Kubernetes cluster that is [supported by Anthos as an attached cluster](https://cloud.google.com/anthos/docs/setup/attached-clusters#prerequisites), I typically use an EKS Cluster

## Preparation Steps

1. Fork this repo and clone locally
2. Run [setup.sh](https://github.com/ggalloro/acm-workshop/blob/master/setup.sh) from the local repo clone and follow prompt to insert user accounts to be used, commit and push to your fork.
3. Create at least 2 Kubernetes clusters, one of them GKE with Network Policy or Dataplane v2 enabled (I typically use 1 GKE and 1 EKS) 
4. (If using non GKE clusters)[Register Clusters](https://cloud.google.com/anthos/multicluster-management/connect/registering-a-cluster) with Anthos Fleet
5. Enable and configure ACM [Config Sync](https://cloud.google.com/anthos-config-management/docs/how-to/installing-config-sync) (synced to the repo fork you created at step 1) and [Policy Controller](https://cloud.google.com/anthos-config-management/docs/how-to/installing-policy-controller) for both clusters
6. Authorize your main user account to log in to the external cluster through [Connect Gateway](https://cloud.google.com/anthos/multicluster-management/gateway/setup) or  a [bearer token](https://cloud.google.com/anthos/multicluster-management/console/logging-in#logging_in_using_a_bearer_token). You must have at least 2 kubectl contexts for your main user account in your local workstation (or whatever workstation you will use to run the workshop) for the 2 clusters
7. Create 2 additional Chrome profiles (or use Chrome Incognito windows) and log in to Google Cloud Shell with each of the 2 'application deployment' user accounts, for each account:
    1. Clone the fork of this repo locally in the Cloud Shell
    2. [Configure cluster access through kubectl](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl) for the GKE cluster (or clusters) 
    3. (only for the 2nd user account) Configure personal access token for Github account

## [Run the Workshop](EXECUTION%20SCRIPT.md)
