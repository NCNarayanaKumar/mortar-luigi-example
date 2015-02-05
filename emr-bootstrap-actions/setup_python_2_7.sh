#!/bin/bash

#
# Copyright 2015 Mortar Data Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# This script sets up python version 2.7 and related tools to
# be the defaults on an EMR instance. This is necessary to use
# python 2.7 for Pig UDFs.
#

# dont cause the bootstrap to fail while we check platform tools
set +e

#
# Detect and setup
# platform specific tools
#
pretty_name_count=`cat /etc/*-release | grep ^NAME= -c`
if [[ $pretty_name_count -gt 0 ]]; then
    pretty_name=`cat /etc/*-release | grep ^NAME= | awk -F '"' '{print $2}'`
    if [[ "$pretty_name" == "Amazon Linux AMI" ]]; then
        # remap yum to use python 2.6 instead of system python,
        # which will fail
        sudo sed -i s/python/python2.6/g /usr/bin/yum
    fi
fi

set -e

# setup python2 alternatives
sudo update-alternatives --install /usr/bin/python2 python2 /usr/bin/python2.5 10
sudo update-alternatives --install /usr/bin/python2 python2 /usr/bin/python2.6 20
sudo update-alternatives --install /usr/bin/python2 python2 /usr/bin/python2.7 100

# use python2.7 for python2
sudo update-alternatives --set python2 /usr/bin/python2.7
sudo ln -s -f /usr/bin/python2 /usr/bin/python

# setup easy-install alternatives
sudo update-alternatives --install /usr/bin/easy_install easy_install /usr/bin/easy_install-2.5 10
sudo update-alternatives --install /usr/bin/easy_install easy_install /usr/bin/easy_install-2.6 20
sudo update-alternatives --install /usr/bin/easy_install easy_install /usr/bin/easy_install-2.7 100

# use easy_install-2.7 for easy_install
sudo rm -f /usr/bin/easy_install
sudo update-alternatives --set easy_install /usr/bin/easy_install-2.7

# setup pip
sudo update-alternatives --install /usr/bin/pip pip /usr/bin/pip-2.7 100

# setup pip-2.7 for pip
sudo rm -f /usr/bin/pip
sudo update-alternatives --set pip /usr/bin/pip-2.7
