#!/bin/ksh
procfile() {
for file
do
        ls -ld $file
        printmenu
        read command
        case "$command" in
        d*|D*)  rm -i $file ;;
        m*|M*)  echo "���� �����祭��:  \c"
                read dest
                mv $file $dest;;
        c*|C*)  cat $file;;
        h*|H*)  head $file;;
        esac
done
printmenu() {
echo d- 㤠���� 䠩�
echo m- ��६����� 䠩�
echo c- �ᯥ���� 䠩�
echo h- �������� ��砫� 䠩��
echo " "
echo "��� �롮�:  \c"
}