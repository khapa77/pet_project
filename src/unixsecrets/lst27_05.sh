#!/bin/sh
#
# Директива LogFormat сервера Apache позволяет создавать
# файлы журнала регистрации специального формата,
# которые включают информацию о запрашиваемом узле, агенте и ссылках.
# Поскольку информация об агентах и ссылках добавлена в журнал регистрации,
# теперь нет необходимости отдельно хранить журналы регистрации агентов и ссылок.
# А поскольку из журнала регистрации можно выбирать строки, 
# относящиеся к данному узлу, то все журналы регистрации
# можно объединить в один. Таким образом, вместо более 250
# дескрипторов файлов для журналов регистрации можно использовать только 2.
# 
# Однако теперь необходимо разработать сценарий обработки данных журнала регистрации 
# для выделения информации, относящейся к каждому домену.
# Теперь регистрация информации будет выполняться так же, как в журнале 
# стандартного формата, но для этого необходимо предпринять
# некоторые дополнительные усилия. 
# Из файла журнала регистрации необходимо выделить информацию,
# относящуюся к каждому домену, а затем разделить ее по
# четырем журналам.
# 

cd /log/httpd

mv combined_log combined_log.use

kill -HUP `cat /var/run/httpd.pid`

cd /web

for i in `ls | grep \\\.`
do
        touch /log/$i/access_log
        touch /log/$i/agent_log
        touch /log/$i/error_log
        touch /log/$i/referer_log
done

for i in `awk '{print $11}' /log/httpd/combined_log.use | \
        cut -d: -f1 |\
        cut -d/ -f1 |\
        sed -e 's/^www.//;s/^WWW.//;s/\.*$//;s/^\"//;s/"$//' |\
        sort -u`
do
        if
                [ X$i = X- ]
        then
                echo \$11 \~ /^$i\$/ { print \$0 } > /tmp/awker
        else
                j=`echo $i | sed -e 's./.\\/.'`
                echo \$11 \~ /$j/ { print \$0 } > /tmp/awker
        fi
        awk -f /tmp/awker /log/httpd/combined_log.use > /tmp/tmp_log
        cut -d\" -f4 /tmp/tmp_log > /tmp/l1
        awk '{print $7}' /tmp/tmp_log > /tmp/l2
        target=`echo $i | tr '[A-Z]' '[a-z]'`
        if 
                [ -d /log/$target ]
        then
                cut -d\  -f1-10 /tmp/tmp_log > \
                        /log/$target/access_log
                paste /tmp/l1 /tmp/l2 |\
                        sed -e 's/        / -> /' |\
                        awk '$1 != "-" { print $0 }' > \
                        /log/$target/referer_log
                cut -d\" -f6 /tmp/tmp_log > /log/$target/agent_log
        else
                cut -d\  -f1-10 /tmp/tmp_log > \
                        /log/hostname.com/access_log
                paste /tmp/l1 /tmp/l2 |\
                        sed -e 's/        / -> /' |\
                        awk '$1 != "-" { print $0 }' > \
                        /log/hostname.com/referer_log
                cut -d\" -f6 /tmp/tmp_log > \
                        /log/hostname.com/agent_log
        fi
        rm -f /tmp/l1 /tmp/l2 /tmp/tmp_log /tmp/awker
done

rm /log/httpd/combined_log.use

for i in `ls | grep \\\.`
do
        if
                [ -d /log/$i ]
        then
                /web/bin/traffic/saver /log/$i
        fi
done
