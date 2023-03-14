#!/bin/bash
#Script that checks ssl certificate on any domain (Script take a list of damains, please specify -p (port) option BEFORE list of your domains.)
# and send notification in zabbix if certificate almost\expiried
#do not need BC calc anymore.

#Written by MentoS

#One big cycle, ends after case cycle (cycle of choosing)
while [ -n "$1" ]; do
 #default port value if port not specified will using 443
 #port="443"
 #choosing options which you specified and processing
 case $1 in
 -p)
  port=$2
  ;;
 -d)
  hosts=$*
  #sorting by separate every domain with comma for future processing
  IFS=', ' read -r -a array <<<"$hosts"
  #some debug
  #echo "${array[2]}"

  #for cycle, take every domain and with openssl client gets begin and end dates of certificate
  #after that cycle cuts it and preproccessing in seconds and after some mathematic operations gets number of DAYS BEFORE EXPIRATION
  #can take negative value.
  for host in "${array[@]}"; do
   end_date=$(openssl s_client -servername "$host" -host "$host" -port "$port" -showcerts -prexit </dev/null 2>/dev/null |
    sed -n '/BEGIN CERTIFICATE/,/END CERT/p' |
    openssl x509 -text 2>/dev/null |
    sed -n 's/ *Not After : *//p')
   if [ -n "$end_date" ]; then
    end_date_seconds=$(date '+%s' --date "$end_date")
    now_seconds=$(date '+%s')
    #Original:
    #echo "($end_date_seconds-$now_seconds)/24/3600" | bc
    #New:
    end_days=$(((end_date_seconds - now_seconds) / 24 / 3600))
    #echo -e "$end_days"
   fi
   #lists of domain:days and just domain for futher zabbix proccessing
   final+=("$host:$end_days")
   fday+=("$end_days")
   #some debug
   #echo "${final[@]}"
   #echo "$host ssl cert expiration date: $end_date"
  done

  #count min and max value from certs dates
  min=0 max=0
  for i in "${fday[@]}"; do
   ((i > max || max == 0)) && max=$i
   ((i < min || min == 0)) && min=$i
  done
  #Almost expiried cert
  #echo "${final[@]}" | grep -o -E "[a-z0-9]+\.[a-z]+\.*[a-z]+:$min"
  echo "${final[@]}" | grep -o -E "[a-z0-9]+\.[.0-9a-z]*[.a-z]*:$min"
  #certificate with maximum expiration date
  #Uncomment if you want this option.
  #echo "${final[@]}" | grep -o -E "[a-z0-9]+\.[a-z]+\.*[a-z]+:$max"
  #some debug
  #echo "min=$min, max=$max"
  ;;
 esac
 shift
done
