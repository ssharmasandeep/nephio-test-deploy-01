#!/usr/bin/env bash
#
# Hook with a schedule binding: sync configsync in target clusters when the cluster object comes to READY state, 
# mark the cluster object as th api version infra.nephio.org/v1alpha1 ready at this point.

source /home/ubuntu/sandeep/nephio-cluster-setup/hooks/common/functions.sh
export PATH="/usr/local/bin:/usr/bin:/bin"


  # Backup of kubeconfig
  cp ~/.kube/config ~/.kube/backupConfig
  # Sync cofigsync kpt package in workload clusters. 
  for cluster in $(kubectl get clusters.infra.nephio.org --all-namespaces -o json | jq -r \
          '(.items[] | select(.metadata.labels."nephio.org/site-status" == "NotReady")).metadata.name')
     do
	     # Check if the ng is READY
	     STATUS=$(kubectl get nodegroup.eks.aws.crossplane.io/$cluster-ng -o json |\
		     jq -r '.status.atProvider.status')
	     if [ $STATUS != "ACTIVE" ]
	     then 
		     echo $cluster $STATUS
		     continue
	     fi

	     #create kubeconfig
             for secret in $(kubectl get secrets --all-namespaces -o json | jq -r --arg cluster "$cluster" \
                     '.items[] | select(.metadata.ownerReferences[0]."name" == $cluster).metadata.name')
             do
                     kubectl get secret $secret -o jsonpath={.data.kubeconfig} | base64 -d > temp
                     KUBECONFIG=~/.kube/config:./temp kubectl config view --flatten >  config
                     mv ./config ~/.kube/config
                     rm temp
             done


             #deploy configsync
             REPO_NAME=$(kubectl get clusters.infra.nephio.org $cluster\
                     -o jsonpath='{.repositoryRef.name}')
             kpt pkg get --for-deployment https://github.com/sandeepAarna/nephio-test-deploy-01.git/rootsync temp
             kpt fn eval temp --save --type mutator --image gcr.io/kpt-fn/search-replace:v0.2.0 \
                     -- by-path=spec.git.repo by-value-regex='https://github.com/[a-zA-Z0-9-]+/(.*)' \
                     put-value="https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"

             kpt fn render temp
             kpt live init temp
             kpt live --context=$cluster apply temp --reconcile-timeout=15m
             rm -rf temp

             # copy secret to workload cluster
             kubectl -n config-management-system get secret -o json | jq -r \
                     "(.items[] | select(.metadata.labels.\"rootsync-secret\" == \"yes\"))\
                     | .metadata |= with_entries(select([.key] | inside([\"name\", \"namespace\", \"labels\"])))" \
                     | kubectl::replace_or_create $cluster

	     #Mark cluster object as Ready
	     kubectl get clusters.infra.nephio.org $cluster -o json | jq -r ".metadata.labels.\"nephio.org/site-status\" = \"Ready\" | .metadata |= with_entries(select([.key] | inside([\"name\", \"namespace\", \"labels\"])))" | kubectl::replace_or_create kubernetes-admin@kubernetes 
     done
