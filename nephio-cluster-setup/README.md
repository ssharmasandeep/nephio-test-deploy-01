## Deploy configSync in workload cluster 

This shell-operator has a hook that runs a cronjob every 3 seconds. It looks for the EKS cluster ojects in READY state and then
creates a kubeconfig file for the cluster followed by syncing configsync to the remote cluster.
The nehpio cluster objects have a label site-status, all objects with label value as notReady are selected for syncing configsync.
Following is the flow, 
* Find the secret which has resource reference as the selected cluster, use this secret to generate a kubeconfig file.
* KPT get the configSync pakage.
* Run the search-replace function to set the git repo for the workload cluster. The value of the gitrepo is read from the cluster object.
* Sync the config sync package in the workload cluster.
* Copy the gihut secret from the Nephio controller cluster to the workloadCluster
* Mark the nephio cluster object as Ready, by setting the site-status label to Ready.

### Using

Build shell-operator image and push it to your Docker registry (replace the repository URL):
```shell
docker build -t "registry.mycompany.com/shell-operator:nephio" . &&
docker push registry.mycompany.com/shell-operator:nephio
```

Edit image in shell-operator-pod.yaml and apply manifests:

```shell
kubectl create ns shell-operator &&
kubectl -n shell-operator apply -f shell-operator-rbac.yaml &&
kubectl -n shell-operator apply -f shell-operator-pod.yaml
```

