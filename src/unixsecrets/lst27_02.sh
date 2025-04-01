#!/bin/sh
#
# $Id: tripweather.sh,v 1.9 1998/12/14 16:27:46 james Exp $
#
# ��� ��������� ����������� ������ �� �������� ������. 
cd /home/james/frio/.data
cp default/trip .
sed -e `/^#/d' trip | cut -d: -f1 > cities
sed -e `/^#/d' trip | cut -d: -f2 > publish
rm trip
maxcit=`cat cities| wc -l`
current=0
rm -f /home/james/frio/.tmp/awkdata2.jca
rm -f /home/james/frio/.tmp/awkdata.jca
#
# ��������� �����. � ����� trip ���������� ��������
# ����������� URL � �������� �������, ��� ������� 
# �������������� ���� ������.
#
BASEURL=http://www.excite.com/weather/forecast/city
export BASEURL
while
        [ $current -lt $maxcit ]
do
        current=`expr "$current" + 1`
        city=`tail +$current cities | sed 1q`
        publish=`tail +$current publish | sed 1q`
        lynx -source $BASEURL/?forecast=${city} > \
                /home/james/frio/.tmp/secondbase
        #
        # ��������� ��������
        #
        high=`grep High /home/james/frio/.tmp/secondbase |\
                egrep -v `winds|level' |\
                sed 1q |\
                cut -d\> -f3 |\
                cut -d\< -f1`
        low=`grep Low /home/james/frio/.tmp/secondbase |\
                egrep -v `level|cloud' |\
                sed 1q |\
                cut -d\> -f3 |\
                cut -d\< -f1`
        #
        # ������ ����������� ��������; 
        # ����� �������� ����. ��������� �������� sed � ������� cut 
        # ������������ ��� �������� ������ ������.
        #
        lin=`grep -n Low /home/james/frio/.tmp/secondbase |\
                egrep -v `level|cloud' | sed 1q | cut -d: -f1`
        lin=`expr "$lin" + 3`
        forecast=`tail +$lin /home/james/frio/.tmp/secondbase |\
                sed `/^</,$d' |\
                cut -d\< -f1`
        #
        # ������ ������������ � ����, ������� �� ����� ����������� 
        #
        echo ${high}:${low}:${publish}:${high}:${low}:${forecast}:${folk} > \
                /home/james/frio/.tmp/awkdata.jca
        #
        # ���������� ��� �� �������� ��� �������� �� ������.
        #
        high=`grep High /home/james/frio/.tmp/secondbase |\
                egrep -v `level|winds' |\
                tail +2 |\
                sed 1q |\
                cut -d\> -f3 |\
                cut -d\< -f1`
        low=`grep Low /home/james/frio/.tmp/secondbase |\
                egrep -v `level|cloud' |\
                tail +2 |\
                sed 1q |\
                cut -d\> -f3 |\
                cut -d\< -f1`
        lin=`grep -n Low /home/james/frio/.tmp/secondbase |\
                egrep -v `level|cloud' |\
                tail +2 |\
                sed 1q |\
                cut -d: -f1`
        lin=`expr "$lin" + 3`
        forecast=`tail +$lin /home/james/frio/.tmp/secondbase |\
                sed `/^</,$d' |\
                cut -d\< -f1`
        echo ${high}:${low}:${publish}:${high}:${low}:${forecast}:${folk} > \
                /home/james/frio/.tmp/awkdata2.jca
        rm /home/james/frio/.tmp/secondbase
done
rm cities publish
#
# ������ �������� ������������� ������ �� �����������
#
sort -t: +0 -1nr +1 -2nr /home/james/frio/.tmp/awkdata.jca >\
        /home/james/frio/.tmp/awkdata3.jca
sort -t: +0 -1nr +1 -2nr /home/james/frio/.tmp/awkdata2.jca >\
        /home/james/frio/.tmp/awkdata4.jca
#
# ���������� ����� � ��������.
#
cat << EOF > /home/james/frio/.tmp/wereport.james
From weather `date`
Date: `date`
From: weather@jamesarmstrong.com (Trip Weather)
To: james@sagarmatha.com, jca@jamesarmstrong.com
Subject: Trip Weather

EOF
echo Today\'s forecast: > /home/james/frio/.tmp/wereport.james
echo " " > /home/james/frio/.tmp/wereport.james
#
# ��������� Awktrip.awk �������� ������ � ������� �� � ������� �������
#
awk -f /home/james/frio/.bin/awkittrip.awk \
        /home/james/frio/.tmp/awkdata3.jca > \
        /home/james/frio/.tmp/wereport.james
echo " " > /home/james/frio/.tmp/wereport.james
echo Tomorrow\'s forecast: > /home/james/frio/.tmp/wereport.james
echo " " > /home/james/frio/.tmp/wereport.james
awk -f /home/james/frio/.bin/awkittrip.awk \
        /home/james/frio/.tmp/awkdata4.jca > \
        /home/james/frio/.tmp/wereport.james
echo " " > /home/james/frio/.tmp/wereport.james
echo "-- " > /home/james/frio/.tmp/wereport.james
cat /home/james/.signature > /home/james/frio/.tmp/wereport.james
cp /home/james/frio/.tmp/wereport.james \
        /home/james/frio/WeatherReport.trip
/usr/sbin/sendmail james@sagarmatha.com < \
        /home/james/frio/.tmp/wereport.james
rm /home/james/frio/.tmp/awkdata* /home/james/frio/.tmp/wereport* 
#
# ������!
#
