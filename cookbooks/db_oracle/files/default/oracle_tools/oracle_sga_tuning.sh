#!/bin/bash -ex
source /etc/profile.d/oracle_profile.sh
$ORACLE_HOME/bin/sqlplus "/ as sysdba" <<__EOF__
ALTER SYSTEM SET SGA_TARGET=`grep 'MemTotal' /proc/meminfo | awk '{print $2 * 60 / 102400}' | cut -f1 -d .`M SCOPE=SPFILE;
commit;
SHUTDOWN ABORT;
STARTUP;
__EOF__

