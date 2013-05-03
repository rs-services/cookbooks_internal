Description
===========

This cookbook will install [Jenkins](http://jenkins-ci.org/), the continuous integration server.

Requirements
============

This cookbook depends on the [apt](http://community.opscode.com/cookbooks/apt), [yum](http://community.opscode.com/cookbooks/yum), sys_firewall and rightscale cookbooks.

Attributes
==========

node[:jenkins][:config] will be set to the correct default configuration location for Jenkins depending on OS.

Usage
=====

In the default configuration Jenkins will listen on port 8080. The install recipe contains templates which will allow inbound port 80 traffic and will forward this traffic via iptables to the configured listening Jenkins port. This listening port can be changed via the 'jenkins/port' dashboard input.
