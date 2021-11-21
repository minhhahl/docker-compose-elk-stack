# Benchmark

Benchmark elastic search with [rally](https://github.com/elastic/rally)

## Run built-in benchmark

- https://esrally.readthedocs.io/en/stable/command_line_reference.html#command-line-reference
- https://esrally.readthedocs.io/en/stable/offline.html#using-tracks
- Run with `--test-mode` to test the setup, it will use 1k documents index. Remove `--test-mode` to run full test.

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

### Run benchmark

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

### Output

```md
|                                                         Metric |                                              Task |     Value |   Unit |
|---------------------------------------------------------------:|--------------------------------------------------:|----------:|-------:|
|                     Cumulative indexing time of primary shards |                                                   |   22.3734 |    min |
|             Min cumulative indexing time across primary shards |                                                   |         0 |    min |
|          Median cumulative indexing time across primary shards |                                                   |         0 |    min |
|             Max cumulative indexing time across primary shards |                                                   |   3.77638 |    min |
|            Cumulative indexing throttle time of primary shards |                                                   |         0 |    min |
|    Min cumulative indexing throttle time across primary shards |                                                   |         0 |    min |
| Median cumulative indexing throttle time across primary shards |                                                   |         0 |    min |
|    Max cumulative indexing throttle time across primary shards |                                                   |         0 |    min |
|                        Cumulative merge time of primary shards |                                                   |  0.971267 |    min |
|                       Cumulative merge count of primary shards |                                                   |        59 |        |
|                Min cumulative merge time across primary shards |                                                   |         0 |    min |
|             Median cumulative merge time across primary shards |                                                   |         0 |    min |
|                Max cumulative merge time across primary shards |                                                   |  0.483267 |    min |
|               Cumulative merge throttle time of primary shards |                                                   |         0 |    min |
|       Min cumulative merge throttle time across primary shards |                                                   |         0 |    min |
|    Median cumulative merge throttle time across primary shards |                                                   |         0 |    min |
|       Max cumulative merge throttle time across primary shards |                                                   |         0 |    min |
|                      Cumulative refresh time of primary shards |                                                   |   9.16542 |    min |
|                     Cumulative refresh count of primary shards |                                                   |       909 |        |
|              Min cumulative refresh time across primary shards |                                                   |         0 |    min |
|           Median cumulative refresh time across primary shards |                                                   |         0 |    min |
|              Max cumulative refresh time across primary shards |                                                   |   3.40035 |    min |
|                        Cumulative flush time of primary shards |                                                   |  0.355633 |    min |
|                       Cumulative flush count of primary shards |                                                   |        64 |        |
|                Min cumulative flush time across primary shards |                                                   |         0 |    min |
|             Median cumulative flush time across primary shards |                                                   |         0 |    min |
|                Max cumulative flush time across primary shards |                                                   |  0.112667 |    min |
|                                        Total Young Gen GC time |                                                   |     0.034 |      s |
|                                       Total Young Gen GC count |                                                   |         1 |        |
|                                          Total Old Gen GC time |                                                   |         0 |      s |
|                                         Total Old Gen GC count |                                                   |         0 |        |
|                                                     Store size |                                                   |  0.352748 |     GB |
|                                                  Translog size |                                                   | 0.0769742 |     GB |
|                                         Heap used for segments |                                                   |  0.949532 |     MB |
|                                       Heap used for doc values |                                                   |  0.378197 |     MB |
|                                            Heap used for terms |                                                   |  0.471985 |     MB |
|                                            Heap used for norms |                                                   | 0.0186157 |     MB |
|                                           Heap used for points |                                                   |         0 |     MB |
|                                    Heap used for stored fields |                                                   | 0.0807343 |     MB |
|                                                  Segment count |                                                   |       166 |        |
|                                                 Min Throughput | bulk index documents into index-with-one-document |      2.48 | docs/s |
|                                                Mean Throughput | bulk index documents into index-with-one-document |      2.48 | docs/s |
|                                              Median Throughput | bulk index documents into index-with-one-document |      2.48 | docs/s |
|                                                 Max Throughput | bulk index documents into index-with-one-document |      2.48 | docs/s |
|                                       100th percentile latency | bulk index documents into index-with-one-document |   384.119 |     ms |
|                                  100th percentile service time | bulk index documents into index-with-one-document |   384.119 |     ms |
|                                                     error rate | bulk index documents into index-with-one-document |         0 |      % |
|                                                 Min Throughput |                             perform simple search |     54.57 |  ops/s |
|                                                Mean Throughput |                             perform simple search |     54.57 |  ops/s |
|                                              Median Throughput |                             perform simple search |     54.57 |  ops/s |
|                                                 Max Throughput |                             perform simple search |     54.57 |  ops/s |
|                                       100th percentile latency |                             perform simple search |    17.922 |     ms |
|                                  100th percentile service time |                             perform simple search |    17.922 |     ms |
|                                                     error rate |                             perform simple search |         0 |      % |

[INFO] Race id is [cb62bc9a-f6dd-4367-a58d-e1d7b0b192bb]

--------------------------------
[INFO] SUCCESS (took 35 seconds)
--------------------------------
```
