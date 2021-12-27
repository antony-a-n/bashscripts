#!/bin/bash
domain=$1

function log_check () {
    echo "checking logs in apache2 error log"
    echo "----------------"
    grep "$domain" /var/log/apache2/error_log | tail -n 100
    echo "----------------"
    echo "checking  POST operations"
    echo "----------------"
    grep -E 'GET|POST' /var/log/apache2/domlogs/$domain-ssl_log
    echo "----------------"
    echo "checking in /var/log messages"
    echo "----------------"
    grep "$domain" /var/log/messages |tail -n100
}

if [ -z "$domain" ];then
    echo "please specify the domain name"
    exit 1
fi

grep "$domain" /etc/userdatadomains >/dev/null 2>&1
if [ $? = 0 ]; then
    username=$(grep "$domain" /etc/userdatadomains | cut -d= -f1 | cut -d" " -f2 | head -n1)
    if [[ -f "/home/$username/public_html/error_log" ]]; then
        log_check
		echo "checking error logs under public_html" 
        echo "----------------"
        tail -n25 /home/$username/public_html/error_log
    else
        log_check
    fi
else
    echo "The doamin isn't in the server"
fi
