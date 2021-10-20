#!/usr/bin/env sh

for phone in $sns_phones; do
  echo $phone
  aws sns publish --phone-number="$phone" --message "$sms_message_body"
done
