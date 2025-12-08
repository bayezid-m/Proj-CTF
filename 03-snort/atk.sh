#!/bin/bash
HOST=192.168.0.10 #ip
PORT=8000 #port
INTERVAL=2 #seconds
USER="ubuntu" #ssh username. User that flag will be sent
NUM=0; #starting
MAX_NUM=5; #end
USERNAME=KalmaNVakinen; #username for website
PASSWORD=CTF{FromBeyondTheGrave}; #password for website
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

echo "flag sent"
scp ~/flag.txt "$USER"@"$HOST":~/Desktop/

done



#notes.
#Remember to add these so ssh does not ask for password:
#ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -C "ubuntu@$(hostname)"
#ssh-copy-id -i ~/.ssh/id_ed25519.pub kayttaja@192.168.1.50
