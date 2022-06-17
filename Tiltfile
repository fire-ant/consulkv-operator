
docker_build('chr1slavery/consulkv-operator', '.', 
    dockerfile='Dockerfile')

ns = """
apiVersion: v1
kind: Namespace
metadata:
  name: consul
spec: {}
status: {}"""
k8s_yaml([
    blob(ns)
])
# load('ext://helm_resource', 'helm_resource', 'helm_repo')
# helm_repo('consul-helm', 'https://helm.releases.hashicorp.com')
# helm_resource('consul', 'consul-helm/consul')
load('ext://helm_remote', 'helm_remote')
helm_remote('consul',
            repo_name='consul-helm',
            repo_url='https://helm.releases.hashicorp.com',
            namespace='consul',
            values='dev/consul-values.yaml')
k8s_resource(workload='consul-server', port_forwards=[8500,8600])
k8s_resource(workload='consul-client', port_forwards=[8301,8302])

# k8s_yaml(helm('consul-helm/consul', name='consul', values='dev/consul-values.yaml'))

k8s_yaml(kustomize('./config/default'))

docker_compose("./docker-compose.yml")
# TESTS
local_resource(name="apply_green",cmd='kubectl apply -f test/green/consul_v1alpha1_consulkv.yaml',trigger_mode=TRIGGER_MODE_MANUAL)
local_resource(name="kv_green",cmd='docker exec sonic-consul consul kv get configs/sw1 | jq .[].localhost.hostname',resource_deps=["apply_green"])
local_resource(name="cfg_green", cmd='docker exec sonic-consul grep green_switch /etc/sonic/config_db.json', trigger_mode=TRIGGER_MODE_MANUAL)
local_resource(name="apply_blue",cmd='kubectl apply -f test/blue/consul_v1alpha1_consulkv.yaml',trigger_mode=TRIGGER_MODE_MANUAL)
local_resource(name="kv_blue",cmd='docker exec sonic-consul consul kv get configs/sw1 | jq .[].localhost.hostname',resource_deps=["apply_blue"])
local_resource(name="cfg_blue", cmd='docker exec sonic-consul grep blue_switch /etc/sonic/config_db.json', trigger_mode=TRIGGER_MODE_MANUAL)
local_resource(name="delete",cmd='kubectl delete -f test/blue/consul_v1alpha1_consulkv.yaml',trigger_mode=TRIGGER_MODE_MANUAL)