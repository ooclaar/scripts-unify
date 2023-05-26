#!/bin/bash

# Basically this script runs via CRON according to your needs and checks the quality 
# of the ping with the provider. In case the number of attempts exceeds 3 over 100ms, 
# a Telegram group is notified.

# ooclaar 

TOKEN="xxx:xxx"
CHAT_ID="@xxxx"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"
FAILURES=0
PING_ATTEMPTS=10
FAILURE_THRESHOLD=3
EXCEEDED_TIMES=""
ISP_INFO=$(curl -s https://ipinfo.io/org)

for i in $(seq 1 $PING_ATTEMPTS)
do
  PING_RESULT=$(ping -c 1 google.com | grep -oP 'time=\K[^\s]+')
  PING_RESULT_INT=${PING_RESULT/./}
  if (( PING_RESULT_INT > 500 )); then # 500 to 50.0 ms or 1000 to 100.0 ms
    FAILURES=$((FAILURES+1))
    EXCEEDED_TIMES+="$PING_RESULT ms, "
  fi
done

if (( $FAILURES >= $FAILURE_THRESHOLD )); then
  MESSAGE="Alert! $FAILURES out of $PING_ATTEMPTS ping attempts exceeded 100ms. Exceeded times: $EXCEEDED_TIMES. ISP info: $ISP_INFO."
  curl -s -X POST $URL -d chat_id=$CHAT_ID -d text="$MESSAGE" > /dev/null
fi
