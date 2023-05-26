#!/bin/bash
# Script that monitors Load Balance changes in EdgeRouter and USG equipment from Unify. The script needs to be configured in Load Balance, so that the equipment can receive the necessary parameters to function.
# You can rename the interfaces to know which configured internet link disconnected.

GROUP=$1
INTF=$2
STATUS=$3

TOKEN="xxx:xxx"
CHAT_ID="@xxx" # or "%40any"

MYLOG="/var/log/wlb"
TS=$(date +"%T")

if [ $INTF = "eth0" ]; then
    QINT="Texnet"
elif [ $INTF = "eth1" ]; then
    QINT="Vivo"
else
    QINT="Algar"
fi

case "$STATUS" in

 active)
   msg="The Link $QINT is Up"
   curl -L "https://api.telegram.org/bot$TOKEN/sendMessage?=null" -H "Content-Type: application/x-www-form-urlencoded" -d "text=$msg" -d "chat_id=$CHAT_ID"
 ;;

 failover)
   msg="The Link $QINT is Down."
   curl -L "https://api.telegram.org/bot$TOKEN/sendMessage?=null" -H "Content-Type: application/x-www-form-urlencoded" -d "text=$msg" -d "chat_id=$CHAT_ID"
 ;;

 *)
    msg="The Link $QINT is Down."
   curl -L "https://api.telegram.org/bot$TOKEN/sendMessage?=null" -H "Content-Type: application/x-www-form-urlencoded" -d "text=$msg" -d "chat_id=$CHAT_ID"

esac

echo $msg >> $MYLOG
exit 0;
