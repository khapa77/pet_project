#!/bin/ksh
function jobps () {
jno=${1}
shift
ps $* -p `jtopid $jno`
}