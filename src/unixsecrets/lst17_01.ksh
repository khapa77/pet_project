#!/bin/ksh
function sortps (){
if 
    [ X$1 = X-r ]
then
    revorder=1
    shift
else 
    revorder=0
fi

ps -A -o ${1},pid,comm,args > /tmp/ps.$$
sed 1q /tmp/ps.$$
if 
    [ "$revorder" -ne 0 ]
then
    tail +2 /tmp/ps.$$ | sort -nr
else
    tail +2 /tmp/ps.$$ | sort -n
fi
}