
Rapidsai
===========

The RAPIDS suite of open source software libraries gives you the freedom to execute end-to-end data science and analytics pipelines entirely on GPUs.


This chart will deploy the following:

- 1 x Dask scheduler with port 8786 (scheduler) and 80 (Web UI) exposed on an external LoadBalancer (default)
- 3 x Dask CUDA workers with RAPIDS environment and a GPU that connect to the scheduler
- 1 x Jupyter notebook (optional) with port 80 exposed on an external LoadBalancer (default)
- All using Kubernetes Deployments

## Installation

### From source

```console
$ git clone https://github.com/rapidsai/helm-chart helm-chart
$ cd helm-chart
$ helm dep update rapidsai
$ helm install --name myname --namespace mynamespace rapidsai
```

## Development

### Testing

```console
$ make test
helm lint rapidsai
==> Linting rapidsai
Lint OK

1 chart(s) linted, no failures
```

## Configuration

The following table lists the configurable parameters of the Rapidsai chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `dask.nameOverride` |  | `"rapidsai"` |
| `dask.fullnameOverride` |  | `"rapidsai"` |
| `dask.scheduler.name` |  | `"scheduler"` |
| `dask.scheduler.image.repository` |  | `"rapidsai/rapidsai"` |
| `dask.scheduler.image.tag` |  | `"cuda10.0-runtime-ubuntu16.04"` |
| `dask.scheduler.image.pullPolicy` |  | `"IfNotPresent"` |
| `dask.scheduler.image.pullSecrets` |  | `null` |
| `dask.scheduler.replicas` |  | `1` |
| `dask.scheduler.serviceType` |  | `"LoadBalancer"` |
| `dask.scheduler.servicePort` |  | `8786` |
| `dask.scheduler.resources` |  | `{}` |
| `dask.scheduler.tolerations` |  | `[{"key": "nvidia.com/gpu", "operator": "Equal", "value": "present", "effect": "NoSchedule"}]` |
| `dask.scheduler.nodeSelector` |  | `{}` |
| `dask.scheduler.affinity` |  | `{}` |
| `dask.webUI.name` |  | `"webui"` |
| `dask.webUI.servicePort` |  | `8787` |
| `dask.webUI.ingress.enabled` |  | `false` |
| `dask.webUI.ingress.tls` |  | `false` |
| `dask.webUI.ingress.hostname` |  | `"dask-ui.rapidsai.example.com"` |
| `dask.webUI.ingress.annotations` |  | `null` |
| `dask.worker.name` |  | `"worker"` |
| `dask.worker.image.repository` |  | `"rapidsai/rapidsai"` |
| `dask.worker.image.tag` |  | `"cuda10.0-runtime-ubuntu16.04"` |
| `dask.worker.image.pullPolicy` |  | `"IfNotPresent"` |
| `dask.worker.image.dask_worker` |  | `"dask-cuda-worker"` |
| `dask.worker.image.pullSecrets` |  | `null` |
| `dask.worker.replicas` |  | `3` |
| `dask.worker.env` |  | `null` |
| `dask.worker.resources.limits.cpu` |  | `1` |
| `dask.worker.resources.limits.memory` |  | `"3G"` |
| `dask.worker.resources.limits.nvidia.com/gpu` |  | `1` |
| `dask.worker.resources.requests.cpu` |  | `1` |
| `dask.worker.resources.requests.memory` |  | `"3G"` |
| `dask.worker.resources.requests.nvidia.com/gpu` |  | `1` |
| `dask.worker.tolerations` |  | `[{"key": "nvidia.com/gpu", "operator": "Equal", "value": "present", "effect": "NoSchedule"}]` |
| `dask.worker.nodeSelector` |  | `{}` |
| `dask.worker.affinity` |  | `{}` |
| `dask.jupyter.name` |  | `"jupyter"` |
| `dask.jupyter.enabled` |  | `true` |
| `dask.jupyter.image.repository` |  | `"rapidsai/rapidsai"` |
| `dask.jupyter.image.tag` |  | `"cuda10.0-runtime-ubuntu16.04"` |
| `dask.jupyter.image.pullPolicy` |  | `"IfNotPresent"` |
| `dask.jupyter.image.pullSecrets` |  | `null` |
| `dask.jupyter.replicas` |  | `1` |
| `dask.jupyter.serviceType` |  | `"LoadBalancer"` |
| `dask.jupyter.servicePort` |  | `80` |
| `dask.jupyter.password` |  | `"sha1:56152965e045:3cd9a2065e78b4a4e46c2d6f35ddd0160fe5b94d"` |
| `dask.jupyter.args` |  | `["bash", "/rapids/notebooks/utils/start-jupyter.sh"]` |
| `dask.jupyter.extraConfig` |  | `"c.ServerProxy.host_whitelist = [\"localhost\", \"127.0.0.1\", \"rapidsai-scheduler\"]"` |
| `dask.jupyter.env` |  | `[{"name": "DASK_DISTRIBUTED__DASHBOARD__LINK", "value": "/proxy/rapidsai-scheduler:8787/status"}]` |
| `dask.jupyter.resources.limits.cpu` |  | `2` |
| `dask.jupyter.resources.limits.memory` |  | `"6G"` |
| `dask.jupyter.resources.limits.nvidia.com/gpu` |  | `1` |
| `dask.jupyter.resources.requests.cpu` |  | `2` |
| `dask.jupyter.resources.requests.memory` |  | `"6G"` |
| `dask.jupyter.resources.requests.nvidia.com/gpu` |  | `1` |
| `dask.jupyter.tolerations` |  | `[{"key": "nvidia.com/gpu", "operator": "Equal", "value": "present", "effect": "NoSchedule"}]` |
| `dask.jupyter.nodeSelector` |  | `{}` |
| `dask.jupyter.affinity` |  | `{}` |
| `dask.jupyter.ingress.enabled` |  | `false` |
| `dask.jupyter.ingress.tls` |  | `false` |
| `dask.jupyter.ingress.hostname` |  | `"jupyter.rapidsai.example.com"` |
| `dask.jupyter.ingress.annotations` |  | `null` |





