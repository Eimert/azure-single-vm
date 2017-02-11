#!/bin/bash
LOG=/var/log/terraform_provision_script.log
echo "" > $LOG
chmod 755 $LOG
exec >> $LOG 2>&1