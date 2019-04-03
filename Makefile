VERSION=5.2.4
IMAGE_TAG=$(VERSION)

container:
	docker build --build-arg GRAFANA_VERSION=$(VERSION) -t registry.yssredefinecloud.com/apm/monitoring-grafana:$(IMAGE_TAG) .
