# ACM GitOps Workshop 
# **Using Source Code Management Patterns to Configure & Secure Kubernetes Clusters**

This repo contains assets to run an [Anthos Config Management](https://cloud.google.com/anthos-config-management/docs/overview) (ACM) workshop.

The workshop shows how to use Anthos Config Management to manage multiple Kubernetes clusters in different environments (GCP, other clouds, on-prem) in order to:

* Centrally configure and manage 'landing-zones' for multiple application deployment teams
* Implement pull request flows to request and approve changes
* Enforce security guardrails through Policy Controller constraints (based on [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper))

The person running the workshop impersonates the 'platform team' and the 'security team' defining managed clusters configurations and security policies (quotas, rbac, network policies, etc...) and, in addition to that, will use two distinct Google accounts to impersonate 2 different application delivery teams deploying workloads in their assigned 'landing zones' defined as namespaces named *application1* and *application2*.

Managed clusters will sync their configuration using Anthos Config Management [Config Sync](https://cloud.google.com/anthos-config-management/docs/config-sync-overview) and security policies will be enforced with Anthos Config Management [Policy Controller](https://cloud.google.com/anthos-config-management/docs/concepts/policy-controller) based on [OPA Gatekeeper](https://github.com/open-policy-agent/gatekeeper).


## Workshop Recordings and Slides ##

This workshop has been run as a talk named **Using Source Code Management Patterns to Configure & Secure Kubernetes Clusters** in the following events:

[GitOps Days 2021](https://youtu.be/u2rmx-2MwNA)

[Codemotion Tech Conference 2021](https://jwp.io/s/Or4kct75) - [Slides](https://www.slideshare.net/GiovanniGalloro/using-source-code-management-patterns-to-configure-and-secure-your-kubernetes-clusters-244972998)

## How to run the workshop ##

1. [Preparation Steps](PREPARATION.md)
2. [Workshop Execution](EXECUTION%20SCRIPT.md)



