#!/usr/bin/env bash
# 不能在Dockerfile使用`RUN source ~/.bash_profile`原因: .bash_profile会新开bash
echo "--- start version-check.sh ---"
/scripts/version-check.sh
echo "--- done version-check.sh ---"

source ~/.bash_profile