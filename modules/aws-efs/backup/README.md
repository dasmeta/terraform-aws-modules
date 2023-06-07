# How to deploy backuper to cluster

- First edit Makefile and set correct values for variables and build image with this command
```
make build-image
```

- then push image to your repository (I guess its ECR)
```
make push-image
```

- Make sure to change image details in helm values (values-dev.yaml)
```
make helm-update-dev:
```

In this start.sh script example backuper will just copy all content of EFS (/) to AWS S3 bucket

but sure you can edit start.sh and add your custom logic there
