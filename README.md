## Setup Cluster

1.  Use SSH keys without passphrase

1.  [Get RKE binary](https://rancher.com/docs/rke/latest/en/installation/#download-the-rke-binary) and add it into `$PATH`

1.  Configure cluster by running `rke config --name cluster.yml`

1.  Make sure there's is one non-loopback nameserver address in `/etc/resolv.conf` (consul to docs of your OS)

1.  Deploy cluster

## Bootstrapping

    export KUBECONFIG=$PWD/kube_config_cluster.yml
    kubectl apply -f bootstrap.yml

## Deploying Containers

### Config

1.  Go to `config` directory:

        cd config

1.  Load config and secret:

        kubectl apply -f config-load.yml

### WrenDS (LDAP)

1.  Go to `ldap` directory:

        cd ../ldap

1.  Deploy OpenDJ pod that generates initial data:

        kubectl apply -f opendj.yml

## Persistence Data

1.  Go to `persistence` directory:

        cd ../persistence

1.  Deploy OpenDJ pod that generates initial data:

        kubectl apply -f persistence.yml

    This will create job to inject data to LDAP.

### nginx Ingress

1.  To allow external traffic to the cluster, we need to deploy nginx Ingress and its controller.

        cd ../nginx

1.  Create secrets to store TLS cert and key:

        sh tls-secrets.sh

1.  Afterwards deploy the custom Ingress for Gluu Server routes.

        kubectl apply -f nginx.yml

### oxAuth

1.  Go to `oxauth` directory:

        cd ../oxauth

1.  Deploy oxAuth pod:

        NGINX_IP=$HOST_IP sh deploy-pod.sh

### oxTrust

1.  Go to `oxtrust` directory:

        cd ../oxtrust

1.  Deploy oxTrust pod:

        NGINX_IP=$HOST_IP sh deploy-pod.sh

## Scaling Containers

To scale containers, run the following command:

    kubectl -n gluu scale --replicas=<number> <resource> <name>

In this case, `<resource>` could be Deployment or Statefulset and `<name>` is the resource name.

Examples:

-   Scaling oxAuth:

        kubectl -n gluu scale --replicas=2 deployment oxauth

-   Scaling oxTrust:

        kubectl -n gluu scale --replicas=2 statefulset oxtrust
