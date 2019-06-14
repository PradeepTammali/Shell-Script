#!/bin/bash
host_log="/home/pradeep/scripts"
install_log="$host_log/tmp.log"
log() {
  ts=`date "+%Y/%m/%d %H:%M:%S"`
  prefix="$ts logging-script: "
  message="$prefix$1"
  echo $message >> $install_log
}
log "INFO  === testing loggin script $host_mapr ==="
