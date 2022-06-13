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
k8s_resource(workload='consul-server', port_forwards=8500)

# k8s_yaml(helm('consul-helm/consul', name='consul', values='dev/consul-values.yaml'))

k8s_yaml(kustomize('./config/default'))