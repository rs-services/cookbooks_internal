#!/bin/sh

SERVER_NAME=NCOM11

#-----------------------------------------------------------------------
# Global Java options
#-----------------------------------------------------------------------

NCOM_SETTINGS=-Dncom.home.path=/ncom/ncom_app
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.configuration.path=/nas/deploy/configure"
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.log.path=/ncom/ncom_app/ncomportal/log/$SERVER_NAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.server.type=Prd"
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.program.name=ncomportal"

NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.deploy.path=/nas/deploy/application/ncomportal"

NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.center.code=Global"

NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.host.name=$HOSTNAME:8080"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.node.name=$SERVER_NAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.server.config.dir=/ncom/ncom_app/ncomportal/conf"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.server.log.dir=/ncom/ncom_app/ncomportal/log/$SERVER_NAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.server.data.dir=/ncom/ncom_app/ncomportal/data/$SERVER_NAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.server.temp.dir=/ncom/ncom_app/ncomportal/tmp/$SERVER_NAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Dorg.jboss.as.logging.per-deployment=false"

NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.cachelayer.off=true"
#JAVA_OPTS="$JAVA_OPTS -Xloggc:/ncom/ncom_app/ncomportal/ncom1.gc.out -XX:+PrintGCDetails"

# Samsung Account
NCOM_SETTINGS="$NCOM_SETTINGS -Dsso.region.code=GC"

#-----------------------------------------------------------------------
# Java options for this Instance
#-----------------------------------------------------------------------
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.was.name=$SERVER_NAME"

# Infinispan
NCOM_SETTINGS="$NCOM_SETTINGS -Djgroups.tcp.address=$HOSTNAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Djgroups.tcp.port=26100"

NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.socket.binding.port-offset=0"

NCOM_SETTINGS="$NCOM_SETTINGS -Djava.net.preferIPv4Stack=true"

#-----------------------------------------------------------------------
# Run WAS
#-----------------------------------------------------------------------

export SERVER_NAME
export NCOM_SETTINGS
