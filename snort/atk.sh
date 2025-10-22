#!/bin/bash
HOST=192.168.0.107
PORT=22
INTERVAL=2         # seconds
USER="ubuntu"
NUM=0;
MAX_NUM=10;

SSH_OUT=$(ssh -oBatchMode=yes -oConnectTimeout=5 -p "$PORT" "$USER@$HOST" true 2>&1)
SSH_EXIT=$?

while (( NUM<MAX_NUM ));do
SSH_OUT=$(ssh -oBatchMode=yes -oConnectTimeout=5 -p "$PORT" "$USER@$HOST" true 2>&1)
SSH_EXIT=$?
if [ $SSH_EXIT -eq 0 ];then
	echo "SSH onnistui";
else
	if echo "$SSH_OUT" | grep -qi "Permission denied"; then
		echo "Permission denied $NUM"
		
	elif echo "$SSH_OUT" | grep -qi "Connection reset by peer";then
		echo "Connection reset by peer $NUM"
		NUM=$((NUM+1))
	else
		echo "muu $SSH_OUT"
		
fi

fi

sleep "$INTERVAL"
done

#change this
while true; do

printf "Flag{YOU_GOT_THIS!!!}\n" | nc -w 2 "$HOST" "$PORT"; 
	echo "flag sent"
sleep "$INTERVAL"
done