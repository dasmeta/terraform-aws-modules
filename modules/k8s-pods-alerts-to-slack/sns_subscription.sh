#!/usr/bin/env sh

sns_region="${sns_region:=us-east-1}"

for email in $sns_emails; do
  echo $email
  echo $sns_region

  aws sns subscribe --topic-arn "$sns_arn" --region="$sns_region" --protocol email --notification-endpoint "$email"
done
