.PHONY: test
test:
	docker run \
		--rm --network host \
		-v $(PWD)/yourrally:/rally/.rally \
		elastic/rally:2.3.0 race \
		--track=http_logs \
		--test-mode \
		--pipeline=benchmark-only \
		--target-hosts=host.docker.internal:9222 \
		--client-options="basic_auth_user:'elastic',basic_auth_password:'changeme'"

.PHONY: benchmark
benchmark:
	docker run \
		--rm \
		--network host \
		-v $(PWD)/myrally:/rally/.rally \
		-v $(PWD)/mytrack:/mytrack \
		elastic/rally:2.3.0 race \
		--offline \
		--track-path=/mytrack \
		--track-params="bulk_size:100,bulk_indexing_clients:10" \
		--pipeline=benchmark-only \
		--target-hosts=host.docker.internal:9222 \
		--client-options="basic_auth_user:'elastic',basic_auth_password:'changeme'"