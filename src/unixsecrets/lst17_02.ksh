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

if 
    [ $# -eq 0 ]
then
    echo Error:  Too few arguments
    return
fi

optstring=""
while 
    [ $# -ne 0 ]
do
    case "${1}" in
    ruser|user|rgroup) optstring=${optstring}${1}, ;;
    group|pid|vsz)     optstring=${optstring}${1}, ;;
    pgid|pcpu|ppid)    optstring=${optstring}${1}, ;;
    nice|etime|time)   optstring=${optstring}${1}, ;;
    tty|comm|args)     optstring=${optstring}${1}, ;;
    *) echo Bad request ${1} 
    return;;
    esac
    shift
done

optstring=${optstring}pid,comm,args
ps -A -o ${optstring} > /tmp/ps.$$
sed 1q /tmp/ps.$$
if 
    [ "$revorder" -ne 0 ]
then
    tail +2 /tmp/ps.$$ | sort -nr
else
    tail +2 /tmp/ps.$$ | sort -n
fi
rm /tmp/ps.$$
}