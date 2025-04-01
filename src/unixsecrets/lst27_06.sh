#!/bin/sh

dt=`date '+%d'`

yesterday=`/web/bin/traffic/yesterday`

mkdir $1/$yesterday
chmod 777 $1/$yesterday

mv $1/access_log $1/$yesterday
mv $1/agent_log $1/$yesterday
mv $1/error_log $1/$yesterday
mv $1/referer_log $1/$yesterday

#
# Резервное копирование файлов
#

cd $1/$yesterday

total=`wc -l < access_log`
total2=`egrep -i ' / |html|cgi' access_log | wc -l`
total3=`awk -f /web/bin/traffic/script2.awk access_log |\
        sed -e 's.,..g'`
total4=`awk '{print $1}' access_log | sort | uniq | wc -l`

cp ../graph/data /tmp/graph
echo ${yesterday}:${total}:${total2}:${total3}:$total4  |\
        sed -e `s. ..g' > /tmp/graph

#
# Построение файла graph
#
awk -f /web/bin/traffic/script3.awk /tmp/graph > ../graph/data
rm /tmp/graph

#
# Удаление начальных нулей.
#

dow=`date '+%w'`

#
# Создание файла еженедельной регистрации
#

if
        [ $dow -eq 0 ]
then
        # Обработка данных за неделю
        lastweek=`/web/bin/traffic/lastweek`

        mkdir $1/$lastweek
        chmod 777 $1/$lastweek

        for i in `/web/bin/traffic/lastweekdays`
        do
                if 
                        [ -d $1/$i ]
                then
                        cd $1/$i
                        gunzip * > /dev/null 2>&1
                        for j in `ls`
                        do
                                cat $j > $1/$lastweek/$j
                        done
                        gzip * > /dev/null 2>&1
                fi
        done
        
        cd $1/$lastweek

        gzip * > /dev/null 2>&1
fi

#
# Создание отчета за месяц
#

if 
        [ $dt -eq 1 ]
then
        lastmonth=`/web/bin/traffic/lastmonth`

        mkdir $1/$lastmonth
        chmod 777 $1/$lastmonth

        cd $1

        rm -f *.gz
        gunzip ${lastmonth}??/*
        rm -f ${lastmonth}/*
        for i in agent error access referer
        do
                cat ${lastmonth}??/${i}_log > ${lastmonth}/${i}_log
        done
        gzip ${lastmonth}??/*

        cd $1/$lastmonth

        gzip * > /dev/null 2>&1

fi

cd $1

#
# Удаление старых файлов и каталогов
#
find ?????? -mtime +45 -type f -print | xargs rm -f
rmdir * > /dev/null 2>&1
