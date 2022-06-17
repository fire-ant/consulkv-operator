## consul-kv-operator

This is an excuse to learn ansible-operator with [operator-SDK](https://github.com/operator-framework/operator-sdk) by way of attempting to apply GitOps to [consul](https://consul.io) key value pairs. 

The operators inner workings enlist the reuse of the python-consul library and the associated [consul_kv](https://docs.ansible.com/ansible/latest/collections/community/general/consul_kv_module.html) modules to create/update/delete KV's.

Please note the design has forgone security in favor of accessibility and is disigned to be used in conjunction with a consul cluster which is in the same cluster/namespace as the operator.

The only CRD currently avialable is the [ConsulKV](config/samples/consul_v1alpha1_consulkv.yaml):

```
apiVersion: ops.consul.io/v1alpha1
kind: ConsulKV
metadata:
  name: consulkv-sample
  namespace: consul
spec:
  key: a_key
  value: |
    {
    "a_json_key" : "a_json_value"
    }
  server: consul-server.consul
```

this is the minimum needed to read/write/delete a KV pair.

### operator sdk

The basis of development has been to use [this tutorial](https://sdk.operatorframework.io/docs/building-operators/ansible/tutorial/) which will help understand the repository layout without rehashing.

### devcontainer local setup

If you are developing on VSCode the accompanying devcontainer containers all the necessary CLI's/packages to build ansible-operators and run a local development setup.

Review the devcontainer setup or the operator SDK to understand what you need to hack onwards. Note that this is a docker in docker setup which may require further effort if you are running podman or anything other than docker-for-mac and vscode locally.

To build the local cluster you can use [kind](https://kind.sigs.k8s.io) or [ctlptl](https://github.com/tilt-dev/ctlptl):
```
kind create cluster
ctlptl create cluster
```
If needed/preferred, you can also use ctlptl to create a local registry and deploy a linked cluster:
```
ctlptl create registry ctlptl-registry
ctlptl create cluster kind --registry ctlptl-registry
``` 

to install the dependencies you can use the tiltfile with [tilt](https://tilt.dev):
```
tilt up
```

to test the operator with some basic commands:
```
kubectl create -f config/samples/consul_v1alpha1_consulkv.yaml
```
if you are using tilt you can see the KV in the ui at https://localhost:8500

You can also see the config in the CR object with 
```
kubectl get ConsulKV consulkv-sample -n consul -o jsonpath='{.spec.value}' | jq .
```
where consulkv-sample is the switch name.

### TESTING

watch grep -A 5 METADATA  /etc/sonic/config_db.json

```
kubectl delete -f config/samples/consul_v1alpha1_consulkv.yaml
```
the delete will take a moment whilst the finalizer runs but should complete after the KV is removed.

shutdown:
```
tilt down
ctlptl delete cluster kind
```