#!/bin/sh

SERVER_NAME=API11

#-----------------------------------------------------------------------
# Global Java options
#-----------------------------------------------------------------------

NCOM_SETTINGS=-Dncom.home.path=/ncom/ncom_app
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.configuration.path=/nas/deploy/configure"
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.log.path=/ncom/ncom_app/ncomservice/log/$SERVER_NAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.server.type=Prd"
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.program.name=ncomservice"

NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.deploy.path=/nas/deploy/application/ncomservice"

NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.host.name=$HOSTNAME:8180"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.node.name=$SERVER_NAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.server.config.dir=/ncom/ncom_app/ncomservice/conf"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.server.log.dir=/ncom/ncom_app/ncomservice/log/$SERVER_NAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Dorg.jboss.as.logging.per-deployment=false"

#NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.cachelayer.off=true"

#-----------------------------------------------------------------------
# Java options for this Instance
#-----------------------------------------------------------------------
NCOM_SETTINGS="$NCOM_SETTINGS -Dncom.was.name=$SERVER_NAME"

# Infinispan
NCOM_SETTINGS="$NCOM_SETTINGS -Djgroups.tcp.address=$HOSTNAME"
NCOM_SETTINGS="$NCOM_SETTINGS -Djgroups.tcp.port=26200"
NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.server.data.dir=/ncom/ncom_app/ncomservice/data/${SERVER_NAME}"

NCOM_SETTINGS="$NCOM_SETTINGS -Djboss.socket.binding.port-offset=100"

NCOM_SETTINGS="$NCOM_SETTINGS -Djava.net.preferIPv4Stack=true"
#-----------------------------------------------------------------------
# Run WAS
#-----------------------------------------------------------------------

export SERVER_NAME
export NCOM_SETTINGS
