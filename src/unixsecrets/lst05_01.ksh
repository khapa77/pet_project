#!/bin/ksh
newpath=""
for elem in `echo $PATH | sed 's/:/ /g'`
do
  if
    [ -d $elem ]
  then
    bad=0
    for nelem in `echo $newpath | sed 's/:/ /g'`
    do
      if
        [ $elem == $nelem ]
      then
        bad=1
      fi
    done
    if
      [ $bad == 0 ]
    then
      newpath=${newpath}:$elem
    fi
        fi
done
PATH=${newpath}
unset newpath elem nelem