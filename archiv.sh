#!/bin/bash -ex

exec 3>&1 1>>/var/log/archiving.log 2>&1

log() {
    echo "[$(date -Is)]" "$@"
}

if [ ! -e "/etc/logrotate.d/archiving" ]
then
  echo "создаем ротацию для логов"
  echo "/var/log/archiving.log {" | sudo tee -a /etc/logrotate.d/archiving
  echo "        weekly" | sudo tee -a /etc/logrotate.d/archiving
  echo "        rotate 12" | sudo tee -a /etc/logrotate.d/archiving
  echo "        compress" | sudo tee -a /etc/logrotate.d/archiving
  echo "        delaycompress" | sudo tee -a /etc/logrotate.d/archiving
  echo "        missingok" | sudo tee -a /etc/logrotate.d/archiving
  echo "        notifempty" | sudo tee -a /etc/logrotate.d/archiving
  echo "        create 644 root root" | sudo tee -a /etc/logrotate.d/archiving
  echo "}" | sudo tee -a /etc/logrotate.d/archiving
fi

ARCHIV_FOLDER=/nfs/bbb
PUBLISH_DIR=/var/bigbluebutton


if [ -e "/tmp/archiving.start" ]
then
  echo "Перенос работает"
else
  log "Старт переноса"
  echo 'start' > /tmp/archiving.start
  rsync -arvuzt $PUBLISH_DIR/recording/ $ARCHIV_FOLDER/recording/ >> /var/log/archiving.log

  log "Перенос завершон"
  rm /tmp/archiving.start

fi

