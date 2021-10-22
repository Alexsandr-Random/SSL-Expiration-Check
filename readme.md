# SSL Expiration Check for Zabbix - automated script to monitor ssl certificates with zabbix
## Written by MentoS

This script was written to help in monitoring, with zabbix, many websites without 100500 items or macroses

What this script can?

* Monitor one or list of domains ssl certififcates expiration dates
* Send notifications before 30 and 7 days expiration of certificates

____
How to install it and use?

* Clone this repo in zabbix custom script directory to install script:

```
cd /usr/lib/zabbix/externalscripts
git clone https://github.com/Alexsandr-Random/SSL-Expiration-Check.git

```
* Import template from this repo in your zabbix monitoring server
Zabbix have simple instruction for this task: 
https://www.zabbix.com/documentation/4.0/manual/xml_export_import/templates

* Add template to your hosts in zabbix 

* Specify one or few domain names (without http\https) in macrose, separated by comma, like here:
```
{$DOMAIN} www.gnu.org, example.com, github.com

```
* IF you use non-standart https port (not 443), specify it on host with macro:
```
{$SSL_PORT} 3000
```
____
#### In future, if community wish to improve this script i would add full support of custom https ports

Enjoy!
