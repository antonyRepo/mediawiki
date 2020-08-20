#!/bin/bash -v

yum update -y
yum install -y wget git

# Install Chef
cd /home/ec2-user
wget https://packages.chef.io/files/stable/chef-workstation/0.13.35/el/7/chef-workstation-0.13.35-1.el7.x86_64.rpm
yum install -y chef-workstation-0.13.35-1.el7.x86_64.rpm 

# Wiki version to be downloaded
echo '{ "wiki_version" : "${wiki_version}" }' > /tmp/release.json

# Download Chef recipes
git clone https://github.com/antonyRepo/mediawiki.git

# Run chef client
cd mediawiki/chef_config_mng/
chef-client -z -r role[media_wiki] --chef-license=accept

# Disable SELinux
echo 0 > /sys/fs/selinux/enforce
