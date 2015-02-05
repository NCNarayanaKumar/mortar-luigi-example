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
# This script installs Mortar's standard python
# packages. You can add additional packages at the end.
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
        package_tool="yum"
        force_flag="-y"
    elif [[ "$pretty_name" == "Ubuntu" ]]; then
        package_tool="apt-get"
        force_flag="--force-yes -y"
    elif [[ "$pretty_name" == "Debian GNU/Linux" ]]; then
        package_tool="apt-get"
        force_flag="--force-yes -y"
    fi
else
    centos_check=`cat /etc/*-release | grep -i centos -c`
    if [[ $centos_check -gt 0 ]]; then
        package_tool="yum"
        force_flag="-y"
    else
        # EMR Hadoop 1 AMIs use an odd hybrid of Red Hat and
        # Debian, with apt-get installed. Assume that.
        package_tool="apt-get"
        force_flag="--force-yes -y"
    fi
fi

set -e
sudo $package_tool update $force_flag

#python-setuptools, should already be installed.  Just making sure.
sudo $package_tool install python-setuptools $force_flag

# Need newer version for the packages 
# below to install properly
cd /tmp
echo 'Installing setuptools'
sudo easy_install "setuptools==7.0"

echo 'Installing nltk'
sudo easy_install "nltk==2.0.4"

echo 'Installing pip'
sudo easy_install "pip==1.5.6"

# Ensure permissions are ok for uninstalling existing packages
# on debian. See https://wiki.debian.org/Python/Policy#Shared_installation_area_for_Python_modules
if [ -d "/usr/share/pyshared" ]; then
    echo 'Setting permissions to allow uninstallation of existing packages'
    sudo chmod a+w -R /usr/share/pyshared/
fi

# Install scikit-learn
echo 'Installing scikit-learn'
sudo easy_install "scikit-learn==0.15.0"

#
# Install any additional python packages
# you need here.
# 

# Give hadoop user ownership of python site-packages
echo 'Setting hadoop user to have ownership of python packages'
sudo chown hadoop -R /usr/lib/python2.7/site-packages/
