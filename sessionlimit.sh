
loader_lock="/mnt/session.lock"

if [ ! -f ${loader_lock} ];
then
	touch ${loader_lock}
	if [[ $1 == "" ]]
	then
		rm /mnt/last_run
		source /mnt/sessionlimit.conf
	#	for i in  $(seq "$start_port" "$end_port")  ; do
		for i in "43700" "15120" "40397" "25488" "36910" "34110" "22947" "57749" "55286" "28867" "43717" "56233" "59793" "35335" "17686" "39122" "51228" "34885" "16692" "37419" "40218" "23332" "45429" "25169" "40358" "39662" "45099" "18994" "48170" "32920" "25575" "24131" "38449" "46707" "37905" "16306" "59404" "55146" "49973" "51569" "14681" "26013" "22351" "10120" "13845" "29781" "49792" "43446" "32287" "40989" "53697" "19214" "24187" "33224" "23964" "14229" "35032" "50071"  ; do
		now=$(date)
                echo $now "Port : "$i >> /mnt/last_run

	#	for x in {1..2} ; do
	#		for i in $(seq "$y" "$y")  ; do
			now=$(date)
			echo "Port : "$i
			timeout 5 tcpdump -nti any not src host $host and port $i | awk '{print $2}'|awk 'BEGIN { FS = "." } { print $1 "."$2"." $3"." $4 }' > /mnt/check_tmp


			count=$(uniq /mnt/check_tmp | wc -l)


			if [ $count -gt 2 ]
			then
				iptables -I INPUT --protocol tcp --dport $i --jump DROP
				echo $now $i " has been blocked !!!" >> /mnt/log
				echo $count
				cat /mnt/check_tmp > /mnt/log.$i
			else
				echo "Allowed"
			fi
			echo ""
			rm /mnt/check_tmp
	#		done
		done
	fi
	rm ${loader_lock}
else
        echo "Has Been Running !!!"
fi

if [[ $1 == "status" ]]
then
	iptables -nvL
elif [[ $1 == "del" ]]
then
	iptables -D INPUT $2
elif [[ $1 == "log" ]]
then
	cat /mnt/log
elif [[ $1 == "who" ]]
then
	source /mnt/sessionlimit.conf
	timeout 5 tcpdump -nti any not src host $host and port $2 | awk '{print $2}'|awk 'BEGIN { FS = "." } { print $1 "."$2"." $3"." $4 }' > /mnt/check_tmp
	uniq /mnt/check_tmp
	rm /mnt/check_tmp
elif [[ $1 == "block" ]]
then
	iptables -I INPUT --protocol tcp --dport $2 --jump DROP
	now=$(date)
	echo $now $i " has been Manual blocked !!!" >> /mnt/log
fi
