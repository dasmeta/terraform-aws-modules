ACCOUNT_ID="<account-id>"
IMAGE_NAME="<image-name>"

aws-login:
	aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.eu-central-1.amazonaws.com

build-image:
	docker build . --file Dockerfile --tag ${IMAGE_NAME}
	docker tag ${IMAGE_NAME} ${ACCOUNT_ID}.dkr.ecr.eu-central-1.amazonaws.com/${IMAGE_NAME}:0.1

push-image:
	docker push "${ACCOUNT_ID}.dkr.ecr.eu-central-1.amazonaws.com/${IMAGE_NAME}:${VERSION}"

helm-update-dev:
	cd helm/jobs && helm upgrade --install -f values-dev.yaml efs-backup .
