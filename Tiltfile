#  build the operator
docker_build('chr1slavery/consulkv-operator', '.', 
    dockerfile='Dockerfile')

#  create the consul namespace
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

# deploy consul
load('ext://helm_remote', 'helm_remote')
helm_remote('consul',
            repo_name='consul-helm',
            repo_url='https://helm.releases.hashicorp.com',
            namespace='consul',
            values='dev/consul-values.yaml')
k8s_resource(workload='consul-server', port_forwards=[8500])
k8s_resource(workload='consul-client', port_forwards=[8301,8302])

# deploy the operator
chart = helm(
    'consulkv-operator-helm/',
    namespace='consul',
    values=['consulkv-operator-helm/values.yaml']
    )
k8s_yaml(chart)

# deploy the external client
docker_compose("./docker-compose.yml")

# TESTS
local_resource(name="apply_green",cmd='kubectl apply -f test/green/consul_v1alpha1_consulkv.yaml',trigger_mode=TRIGGER_MODE_MANUAL)
local_resource(name="kv_green",cmd='docker exec sonic-consul consul kv get configs/sw1 | jq .[].localhost.hostname',resource_deps=["apply_green"])
local_resource(name="cfg_green", cmd='sleep 6 && docker exec sonic-consul grep green_switch /etc/sonic/config_db.json', trigger_mode=TRIGGER_MODE_MANUAL,resource_deps=["kv_green","apply_green"])
local_resource(name="apply_blue",cmd='kubectl apply -f test/blue/consul_v1alpha1_consulkv.yaml',trigger_mode=TRIGGER_MODE_MANUAL)
local_resource(name="kv_blue",cmd='docker exec sonic-consul consul kv get configs/sw1 | jq .[].localhost.hostname',resource_deps=["apply_blue"])
local_resource(name="cfg_blue", cmd='sleep 6 && docker exec sonic-consul grep blue_switch /etc/sonic/config_db.json', trigger_mode=TRIGGER_MODE_MANUAL,resource_deps=["kv_blue","apply_blue"])
local_resource(name="delete",cmd='kubectl delete -f test/blue/consul_v1alpha1_consulkv.yaml',trigger_mode=TRIGGER_MODE_MANUAL,resource_deps=["cfg_blue"])

