#!/bin/sh
dir="/home/wwwroot/default/gokafka/"
function restartConsumer(){
/usr/bin/sh $dir"kafka-goconsumer.sh" restart
}
isclose="0"
function checkIsClose(){
 file=$dir$1
 if [ `grep -c "Closing consumer" $file` -eq '0' ]; then
     	
    exit 0
else
    isclose="1"
    echo "close"
fi
}
                for file in $dir/*
                do
                    fileName=$(basename $file)
		   ext=${fileName##*.}
		if [ "$ext" == "out" ];then
		checkIsClose $fileName	
		fi	

                done
if [ $isclose == "1" ];then
echo "isclose"
restartConsumer
fi
