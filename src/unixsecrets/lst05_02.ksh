#!/bin/ksh
# Здесь поместите заголовки, требуемые в вашей системе
function usage
{
 echo uuto -D machine!user files ...
}

if (( ${#@} < 2 ))
then
  echo Must have more arguments.
  usage
  exit
fi

dest=none
mflag=""
while
  getopts mD: KEY 
do
  case "$KEY" in
  D) dest=$OPTARG;;
  m) mflag="-m";;
  *) echo Illegal argument; usage;;
  esac
done

destmachine=`echo $dest | cut -d! -f1`
destuser=`echo $dest | cut -d! -f2`

if
  [ "$destmachine" == "" ]
then
  echo A remote host must be specified.
  usage
  exit
fi

if 
  [ "$destuser" == "" }
then
  echo A remote user must be specified.
  usage
  exit
fi

host=`hostname`
for file
do
  uucp ${mflag} -n${destuser} $file ${destmachine}!~/receive/${destuser}/${host}
done