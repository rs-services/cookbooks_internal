#!/bin/sh
### BEGIN INIT INFO
# Provides: jboss
# Required-Start: $local_fs $remote_fs $network $syslog
# Required-Stop: $local_fs $remote_fs $network $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: Start/Stop JBoss AS v7.1.1
### END INIT INFO
#

JBOSS_HOME=/usr/local/jboss
JAVA_HOME=$(readlink /usr/java/latest)
prog="JBoss AS"
export JAVA_HOME
export JBOSS_HOME


EXEC=${JBOSS_HOME}/bin/standalone.sh

if [ -e /etc/redhat-release ]; then
        . /etc/init.d/functions
fi


do_start(){
        if [ -e /etc/redhat-release ]; then
                daemon  --user jboss ${EXEC} > /dev/null 2> /dev/null &
        else
                start-stop-daemon --start --chuid jboss --user jboss --name jboss -b --exec ${EXEC}
        fi
}

do_stop(){
        if [ -e /etc/redhat-release ]; then
                killall -u jboss
        else
                start-stop-daemon --stop -u jboss
        fi
        rm -f ${PIDFILE}
}

rh_status() {
    if [ `ps aux | grep -c ^jboss` != "0" ]; then
      echo "$prog is running... "
      return 0
    else
      echo "$prog is not running..."
    fi
}

case "$1" in
    start)
        echo "Starting JBoss AS"
        do_start
    ;;
    stop)
        echo "Stopping JBoss AS"
        do_stop
    ;;
    status)
        rh_status
    ;;
    restart)
        echo "Restarting JBoss AS"
        do_stop
        sleep 10
        do_start
    ;;
    *)
        echo "Usage: /etc/init.d/jboss {start|stop|status|restart}"
        exit 1
    ;;
esac

exit 0
