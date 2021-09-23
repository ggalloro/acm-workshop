# ACM Workshop - Workshop Run

1. Open a terminal window on your local workstation (or whatever workstation you will use to run the workshop) and, assuming your GKE cluster kubectl context is named `gke-cluster` (change appropriately if it isn't) run: 
`watch kubectl --context=gke-cluster get ns -l type=application`
2. Open another terminal window and, assuming your non GKE cluster kubectl context is named `eks-cluster` (change appropriately if it isn't) run: 
`watch kubectl --context=eks-cluster get ns -l type=application`
3. Show managed kubernetes clusters in GCP Console
4. Show kubectl contexts from a 3rd terminal window on your local workstation
5. Show ACM configuration from GCP console, show the repo URL
6. Show the repo fork page on Github
7. Show repo structure from your local workstation (I typically use Vscode for this)
8. From the assets folder in your local repo copy all the content of the `assets/namespaces` folder inside `config-root/namespaces`
9. Explore/explain how ACM applies configurations to namespaces based on folder structure
10. Explore/describe all resource manifests (namespaces, network policy, quota, role bindings) and how each user account has been granted access only to his dedicated namespace
11. Add new files to repo, commit and push, after that look at the 2 terminal windows where you are watching namespaces with the `type=application`label
12. Check that the namespaces are created
13. From the Chrome profile assigned to the 1st app deployment account (or an incognito window), log in to GCP as the 1st user account and launch Cloud Shell
14. Run `kubectl apply -f ~/acm-workshop/assets/httpbin.yaml -n application1` to deploy the httpbin test application in the assigned namespace *application1*, this should succeed 
15. Try to do the same on the *application2* namespace: `kubectl apply -f ~/acm-workshop/assets/httpbin.yaml -n application2`, you should get autorization errors since the account doesn't have the rights to deploy anything on the *application2* ns
16. Run `kubectl describe ns application1` to view the resource quotas applied to the namespace and how much is used
17. Run `kubectl run big --image=nginx --requests=cpu=2,memory=1Gi -n application1` to try exceeding the assigned quota, you should get an error
18. From the Chrome profile assigned to the 2nd app deployment account (or an incognito window), log in to GCP as the 2nd user account and launch Cloud Shell
19. Run `kubectl apply -f ~/acm-workshop/assets/httpbin.yaml -n application1` , this time you should get an autorization error since the 2nd account has only permission to deploy to *application2*
20. Run `kubectl apply -f ~/acm-workshop/assets/httpbin.yaml -n application2` this time deployment succeed
21. Deploy also the client test application sleep in the same namespace: `kubectl apply -f ~/acm-workshop/assets/sleep.yaml -n application2`
22. Try to connect from sleep to the httpbin pod in the same namespace executing: `kubectl exec "$(kubectl get pod -l app=sleep -n application2 -o jsonpath={.items..metadata.name})" -c sleep -n application2 -- curl httpbin.application2:8000/headers` , you should get a response containing the request header
23. Try to do the same, but pointing to the httpbin pod running in namespace *application1*: `kubectl exec "$(kubectl get pod -l app=sleep -n application2 -o jsonpath={.items..metadata.name})" -c sleep -n application2 -- curl httpbin.application1:8000/headers` , this should fail because the [ns-isolation](assets/namespaces/ns-isolation.yaml) network policy, you applied to all namespaces, allows inbound connections only from the same namespace, so, in this case, only from *application1*.
24. Switch to the other Chrome window where you have the 1st account Cloud Shell, check the network policy: `kubectl describe networkpolicy ns-isolation -n application1`
25. Let's pretend that the *application1* owner, having the admin role for that namespace, try to delete the network policy to allow inbound connections from the *application2* namespace, try to delete it: `kubectl delete networkpolicy ns-isolation -n application1` , you get an error because the object is centrally managed by ACM
26. Let's try a proper, 'GitOps' way, of request a change to this policy, switch to the 2nd user account window and log in to the 2nd user github account from the browser
27. From there, create a fork of the main repo (from the fork made to your account)
28. From the 2nd account Cloud Shell, move in the account home directory (exit from the main repo directory) and clone the forked repo in a directory with a new name (for example: *forked*)
29. Move in the repo clone directory: `cd forked/`  and create a new branch: `git checkout -b network`
30. Edit the local copy of the network policy manifest, for example: `vim config-root/namespaces/ns-isolation.yaml` and add, in the ingress section, a NamespaceSelector selecting all the namespaces with the label `type=application`, as in the example manifest [allow-application-traffic.yaml](assets/allow-application-traffic.yaml) , the ingress section should be as follows:
```
  ingress:
  - from:
    - podSelector: {}
    - namespaceSelector:
        matchLabels:
          type: application
```
31. Save and exit
32. Add the file and commmit, example: `git commit -am "network request"`
33. Push to the network branch: `git push origin network` , authenticate with Personal Access Token if needed
34. Open a pull request on the main repo as instructed by git output
35. Switch to the Github page for the main account, go to *Pull Requests*, you should see the pull request, review the proposed changes (this could be a 'Source Code Management' way of requesting and approving a new 'firewall rule') and merge it, look at the commit id
36. Switch to the 1st account Cloud Shell, run `kubectl describe networkpolicy ns-isolation -n application1` again, you should see that the first 7 digits of the *configmanagement.gke.io/token:* annotation are the same of the commit id
37.  Switch to the 2nd account Cloud Shell, try again the connection from sleep pod in *application2* ns to httpbin in *application1*: `kubectl exec "$(kubectl get pod -l app=sleep -n application2 -o jsonpath={.items..metadata.name})" -c sleep -n application2 -- curl httpbin.application1:8000/headers` this time should work
38. Let's move to Policy Controller and security enforcement through OPA Gatekeeper constraints: from a terminal window on your local workstation, using your GKE cluster kubectl context, list the constraint templates installed in your GKE Cluster: `kubectl get constrainttemplates`
39. Examine the *k8sallowedrepos* template: `kubectl describe constrainttemplate k8sallowedrepos` , this is used to create constraints to limit the pull of images only from trusted container registries
40. Examine the [trusted-repo.yaml](assets/trusted-repo.yaml) constraint manifest, based on the above template, in the repo assets folder. It allows to pull images only from the `europe-docker.pkg.dev/galloro-demos/trusted` Artifact Registry repository and applies only to the *application1*, *application2* and *default* namespaces
41. Try to run a pod pulling from the docker hub on your cluster: `kubectl run illegalrepo --image=nginx` this should work
42. Copy the the [trusted-repo.yaml](assets/trusted-repo.yaml) constraint manifest to the `config-root/cluster`folder in the repo (this is where all the cluster wide resources should be placed), add file, commit, pull changes from remote to get latest changes and push, clusters will update their configuration with the constraint.
43. Retry to run an image from Docker Hub: `kubectl run illegalrepo2 --image=nginx` this time you should get an error similar to:
```
Error from server ([trusted-repo] container <illegalrepo2> has an invalid image repo <nginx>, allowed repos are ["europe-docker.pkg.dev/galloro-demos/trusted"]): admission webhook "validation.gatekeeper.sh" denied the request: [trusted-repo] container <illegalrepo2> has an invalid image repo <nginx>, allowed repos are ["europe-docker.pkg.dev/galloro-demos/trusted"]
```
44. Try to pull from a trusted repo: `kubectl run legalrepo --image=europe-docker.pkg.dev/galloro-demos/trusted/nginx` , the pod should run succesfully this time
45. You can test/show other constraints, as all the ones enforcing Pod Security Policies: try to run a privileged pod applying the [nginx-privileged1.yaml](assets/nginx-privileged1.yaml) manifest to your cluster, it should be able to run 
46. Copy the [noprivileged.yaml](assets/noprivileged.yaml) constraint manifest to the `config-root/cluster` folder in the repo, commit and push.
47. Retry to run a privleged pod, this time applying the [nginx-privileged2.yaml](assets/nginx-privileged2.yaml) manifest (to avoid name conflict), this time you should get an error:
```
Error from server ([psp-privileged-container] Privileged container is not allowed: nginx, securityContext: {"privileged": true}): error when creating "acm-workshop/assets/nginx-priviledged1.yaml": admission webhook "validation.gatekeeper.sh" denied the request: [psp-privileged-container] Privileged container is not allowed: nginx, securityContext: {"privileged": true}
```
