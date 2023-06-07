#!/bin/bash

mount -t nfs <efs-ip>:/ ./efs
# To backup all EFS to s3 you can just leave as it is (rename bucket name)
aws s3 cp --recursive ./efs s3://<your-bucket>-"$(date +%d-%m-%Y)"
