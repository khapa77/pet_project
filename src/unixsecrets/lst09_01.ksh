#!/bin/ksh
procfile() {
for file
do
        ls -ld $file
        printmenu
        read command
        case "$command" in
        d*|D*)  rm -i $file ;;
        m*|M*)  echo "Место назначения:  \c"
                read dest
                mv $file $dest;;
        c*|C*)  cat $file;;
        h*|H*)  head $file;;
        esac
done
printmenu() {
echo d- удалить файл
echo m- переместить файл
echo c- распечатать файл
echo h- показать начало файла
echo " "
echo "Ваш выбор:  \c"
}