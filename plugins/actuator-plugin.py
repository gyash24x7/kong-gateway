import sys
sys.path.append('/usr/local/lib/python3.10/dist-packages')

import kong_pdk.pdk.kong as kong_pdk
from kubernetes import client as k8s_client, config as k8s_config

Schema = [
    {"AUTH_HEADER_NAME": {"type": "string"}}
]
version = "1.0.0"
priority = 1000


class Plugin:

    def __init__(self, config):
        self.config = config

    def access(self, kong: kong_pdk.kong):
        kong.log("Access Phase Invoked!")
        kong.log("Config: " + self.config["AUTH_HEADER_NAME"])

        path = kong.request.get_path_with_query()
        kong.log("Path: " + path)

        k8s_api = k8s_client.CoreV1Api()

        pod_list = k8s_api.list_namespaced_pod("default")
        kong.log(pod_list)
        for pod in pod_list:
            kong.log("Pod Ip: " + pod.status.pod_ip)
            kong.log("Pod Name: " + pod.metadata.name)


