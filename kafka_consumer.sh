#!/bin/sh
basepath=$(cd `dirname $0`; pwd)
fileName=$basepath'/consumerTopics'
yiiConsole='/home/wwwroot/default/lottery/yii'
command='kafka-consumer/consumer'
phpFileDir='/home/wwwroot/default/lottery/modules/tools/kafka'
excludePhpfile='Kafka'
case $1 in 
	list)
		lists=$(ps x | grep -w "$command" | grep -v grep | awk '{print $8}')
		echo -e $lists
	;;
	add)
		if [ ! -n "$2" ] ;then
			echo "请输入主题";
		else
    	    #echo $2 >> $fileName
			nohup $yiiConsole $command $2 > $basepath'/'$2".out" 2>&1 &
			echo "nohup $yiiConsole $command $2 & 2>&1 >>$basepath/$2.out"
			#nohup $yiiConsole" "$command" "$2 &
			echo "add topic $2"
		fi
	;;
	stop)
		if [ ! -n "$2" ] ;then
			echo "请输入主题";
		else
		                pid=$(ps x | grep -w "$yiiConsole $command $2" | grep -v grep | awk '{print $1}')
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
        kill)
                if [ ! -n "$2" ] ;then
                        echo "请输入主题";
                else
			 read -p "确认强杀($2)？确认输入 yes " sureKill			
                	if [[ "$sureKill" != "yes" ]];then
				echo 'no kill'
                        	exit 1
               		 fi                
                                pid=$(ps x | grep -w "$yiiConsole $command $2" | grep -v grep | awk '{print $1}')
                                if [ "$pid" ];then
				echo 'kill topic:'$2
                                echo $pid
                                kill -9 $pid
				else
				echo 'no topic to kill'		
                                fi
                   # echo "kill kafka consumer..."
                fi
        ;;
	addAll)
		for file in $phpFileDir/*
		do
		    fileName=$(basename $file)
		    topicName=${fileName%.*}
		    #echo $excludePhpfile
		    if [[ "$topicName" != "$excludePhpfile" ]];then
 			pid=$(ps x | grep -w "$yiiConsole $command $topicName" | grep -v grep | awk '{print $1}')
                        if [ ! -n "$pid" ];then
                                nohup $yiiConsole $command $topicName > $basepath'/'$topicName".out" 2>&1 &
                        fi 
		    fi	
		    
		done
	   echo "addAll kafka consumer..."
	;;

	*) 
		echo "$0 {list|add|stop|addAll|kill}"
		exit 4
	;;
esac
