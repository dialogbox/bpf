base:
	docker build -f Dockerfile.bpfbase -t dialogbox/bpfbase:latest .

base-push: base
	docker push dialogbox/bpfbase:latest

cos: base
	docker build -f Dockerfile.cos --build-arg BUILD_ID=$(BUILD_ID) -t dialogbox/bpftools:cos-$(BUILD_ID) .

cos-push: cos
	docker push dialogbox/bpftools:cos-$(BUILD_ID)
