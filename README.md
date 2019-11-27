# RAPIDS Helm Chart

## Installation

### From source

```console
$ git clone https://gitlab-master.nvidia.com/jtomlinson/rapidsai-helm-chart.git helm-chart
$ cd helm-chart
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
