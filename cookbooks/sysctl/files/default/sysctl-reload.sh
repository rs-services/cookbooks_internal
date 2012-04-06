#!/bin/bash -e

cat /etc/sysctl.d/* > /etc/sysctl.conf
/sbin/sysctl -p
