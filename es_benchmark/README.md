# Benchmark

Benchmark elastic search with [rally](https://github.com/elastic/rally)

## Run built-in benchmark

- https://esrally.readthedocs.io/en/stable/command_line_reference.html#command-line-reference
- https://esrally.readthedocs.io/en/stable/offline.html#using-tracks

```bash
docker run \
  --rm \
  --network host \
  -v $PWD/yourrally:/rally/.rally \
  elastic/rally:2.3.0 race \
  --track=http_logs \
  --test-mode \
  --pipeline=benchmark-only \
  --target-hosts=host.docker.internal:9222 \
  --client-options="basic_auth_user:'elastic',basic_auth_password:'changeme'"
```

## Create custom benchmark

- https://blog.searchhub.io/how-to-setup-elasticsearch-benchmarking
- Update document in `mytrack/index-with-one-document.json`
- Use different `bulk_size` and `bulk_indexing_clients` in `track-params` to see the performance change

```bash
docker run \
  --rm \
  --network host \
  -v $PWD/myrally:/rally/.rally \
  -v $PWD/mytrack:/mytrack \
  elastic/rally:2.3.0 race \
  --offline \
  --track-path=/mytrack \
  --track-params="bulk_size:100,bulk_indexing_clients:10" \
  --pipeline=benchmark-only \
  --target-hosts=host.docker.internal:9222 \
  --client-options="basic_auth_user:'elastic',basic_auth_password:'changeme'"
```
