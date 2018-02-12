#!/bin/sh
basepath=$(cd `dirname $0`; pwd)
fileName=$basepath'/consumerTopics'
yiiConsole='/home/wwwroot/gokafka/kafkaConsumer'
phpFileDir='/home/wwwroot/default/lottery/modules/tools/kafka'
excludePhpfile='Kafka'
function stopAll(){
                                pid=$(ps x | grep -w "$yiiConsole" | grep -v grep | awk '{print $1}')
                                if [ "$pid" ];then
                                echo 'stop topic:'$2
                                echo $pid
                                kill -2 $pid
                                else
                                echo 'no topic to stop'         
                                fi
}
function addAll(){
                for file in $phpFileDir/*
                do
                    fileName=$(basename $file)
                    topicName=${fileName%.*}
                    #echo $excludePhpfile
                    if [[ "$topicName" != "$excludePhpfile" ]];then
                        pid=$(ps x | grep -w "$yiiConsole $topicName" | grep -v grep | awk '{print $1}')
                        if [ ! -n "$pid" ];then
                                nohup $yiiConsole $topicName >> $basepath'/'$topicName".out" 2>&1 &
                        fi
                    fi

                done
           echo "addAll kafka consumer..."
}
case $1 in 
	list)
		lists=$(ps x | grep -w "$yiiConsole" | grep -v grep | awk '{print $6}')
		echo -e $lists
	;;
	add)
                if [ ! -n "$2" ] ;then
                        echo "?????";
                else
                num=1
                        if [ "$3" ];then
                               num=$3
                        fi
                        echo $num
                        for((i=1;i<=$num;i++));
                        do
            #echo $2 >> $fileName
                        nohup $yiiConsole $2 >> $basepath'/'$2".out" 2>&1 &
                        echo "nohup $yiiConsole $2 & 2>&1 >>$basepath/$2.out"
                        #nohup $yiiConsole" "$command" "$2 &
                        echo "add topic $2"
                done
                fi
        ;;
	stop)
		if [ ! -n "$2" ] ;then
			echo "?????";
		else
		                pid=$(ps x | grep -w "$yiiConsole $2" | grep -v grep | awk '{print $1}')
                                if [ "$pid" ];then
                                echo 'stop topic:'$2
                                echo $pid
                                kill -2 $pid
                                else
                                echo 'no topic to stop'         
                                fi
		    echo
		fi
	;;
        stopAll)


                         read -p "yes? " sureKill
                        if [[ "$sureKill" != "yes" ]];then
                                echo 'no stop'
                                exit 1
                         fi
                         stopAll;
        ;;
	addAll)
		            addAll;
             
	;;
        restart)
                            stopAll;
			 sleep 1;	
			    addAll;	
                
        ;; 
	*) 
		echo "$0 {list|add|stop|addAll|stopAll|restart}"
		exit 4
	;;
esac
