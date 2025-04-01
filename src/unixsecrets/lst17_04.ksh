#!/bin/ksh
function pseudooptps (i) {
integer j
ps -ef > /tmp/ps.$$
j=1
for i
do
   case $i in
   USER) cut -c1-8 /tmp/ps.$$ > /tmp/ps.$$.$j ;;
   PID) cut -c9-14 /tmp/ps.$$ > /tmp/ps.$$.$j ;;
   PPID) cut -c15-20 /tmp/ps.$$ > /tmp/ps.$$.$j ;;
   C) cut -c21-24 /tmp/ps.$$ > /tmp/ps.$$.$j ;;
   STIME) cut -c25-33 /tmp/ps.$$ > /tmp/ps.$$.$j ;;
   TTY) cut -c34-40 /tmp/ps.$$ > /tmp/ps.$$.$j ;;
   TIME) cut -c41-46 /tmp/ps.$$ > /tmp/ps.$$.$j ;;
   CMD) cut -c47- /tmp/ps.$$ > /tmp/ps.$$.$j ;;
   *)  continue
   esac
   j++
done
case $# in
 1) cat /tmp/ps.$$.1 ;;
 2) paste /tmp/ps.$$.1 /tmp/ps.$$.2
 3) paste /tmp/ps.$$.1 /tmp/ps.$$.2 /tmp/ps.$$.3
esac
rm /tmp/ps.$$*
}