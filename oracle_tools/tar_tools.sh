#!/bin/bash -ex

tar -cpf ../cookbooks/oracle/files/default/oracle_tools.tar *.rb *.sh --exclude=tar_tools.sh

