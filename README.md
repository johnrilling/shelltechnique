# shelltechnique
==============
## Shell based Configuration Management Framework

#### Summary:
========
Shell based configuration management framework using native Linux tools:
shell + cronjobs + revision control


#### Benefits:
========= 
1. Agentless - No daemon or installation of additional languages(Ruby Gems, Python modules, etc). 
2. Deployment phase: a single entry in a crontab file !
3. No version conflicts, no upgrades.
3. No wasted time learning abstract DSL languages. 
4. Radically reduced code set therefore less security risk.
6. Almost no CPU/RAM/Disk/Network/Backplane consumption.
7. Mean time to production (Minimal - ideal for continuous integration environments -"Warp 10 Scotty").
8 Leverages the "Lingua Franca" of all Linux admins/DevOps aka the shell.
9. Large scale deployment capability.
10. Simplicy is elegance AND power 


#### Architectural Overview: Simplicity is Elegance
=======================
1. Setup cron to pull instructions(shell scripts/config files/policies) from a configuration server.
2. Cron regularlt executes these instructions applying configuration policies and maintaining server state.

Note: All instructions are maintained on a revision control server.
Example file structure on revision control server is as follows.
* /servers/devserver001/
* /servers/devserver002/
* /servers/devserver003/
...

Each directory contains.
1. instructions.sh - configuration script bringing client server into compliance with corporate policies
2. configuration files - files we want to install on client server i.e. ldap.conf, sudoers, httpd.conf, my.cnf
3. instructions.tar.gz a compressed bundle of instructions.sh and associated configuration files 


#### Architectural Notes:
====================
1. Configure all server crontabs with a similar entry.
```
*/15 * * * * /root/get-instructions.sh/
```

2. /root/get-instructions.sh contains the following.
```
cfgmgtserver = mycfgmgtserver001.mydomain.com
rsync -avzhe ssh root@$cfgmgtserver:/instructions.tar.gz /root/instructions.tar.gz
tar -xzvf /root/instructions.tar.gz
/root/instructions/instructions.sh
```

Note: the difference between.
```
"get-instructions.sh" which simply grabs instructions.tar.gz from our configuration management server
"instructions.tar.gz" bundled and compressed config files and "instructions.sh" 
"instructions.sh" is the configuration policy script maintaining client system state.
```

# Example 1: Install and Configure RPM REPO on company dev servers
====================================================================
Repo configuration policy for company CENTOS development servers

Desired System State is as follows:

```
File Location: /root/instructions/companyrepo.repo /etc/yum.repos.d/
mv /root/instructions/companyrepo.repo /etc/yum.repos.d/

File Perms: 644 
chmod 644 /etc/yum.repos.d/companyrepo.repo

File Ownership: root
chown root.root /etc/yum.repos.d/companyrepo.repo

Action: Import REPO GPG key
rpm --import /root/instructions/RPM-GPG-KEY.txt /etc/path/to/mygpgkeys/

File Ownership: root
chown root.root /etc/path/to/mygpgkeys/*

File Perms: /etc/path/to/mygpgkeys/
chmod 600 /etc/path/to/mygpgkeys/*

Action: Sync with REPO
yum update
```

# Example 2: Install and maintain LDAP configuration policy on company dev servers
==========================================================================================
LDAP configuration policy for company CENTOS development servers

Desired State is as follows:

```
Required dependency must execute first
yum update 

Package State: Installed
yum -y install openldap openldap-clients openldap-servers

File Location: /root/instructions/ /etc/openldap/slapd.d/

File Perms: 600
chmod 600 /etc/openldap/slapd.d/*

File Ownership: root
chown root.root. /etc/openldap/slapd.d/*

Service State: Start on boot
chkconfig slapd on --level 3

Service Stage: On
service slapd start
```

# Example 3: Install and maintain SUDO configuration policy on company dev servers
================================================================================
SUDO Configuration Policy for company CENTOS development servers

Desired State is as follows:

```
Required dependency must execute first
yum update 


File Location: /root/instructions/sudoers /etc/
mv /root/instructions/sudoers /etc/

File Perms: 755
chown 755 /etc/sudo/sudoers.conf 

File Ownership: root
chown root.root /etc/sudoers
```

# Example 4: Install and maintain the configuration policy for apache on company dev servers
==========================================================================================
Apache configuration policy for company CENTOS development servers

Desired System State is as follows:

```
Required dependency must execute first
yum update 

Package State: Installed
yum -y install httpd 

File Location: /root/instructions/httpd.conf
mv /root/instructions/httpd.conf /etc/httpd/conf/httpd.conf

File Perms State: 755
chown 755 /etc/httpd/conf/httpd.conf 

Service State: Started on system reboot
chkconfig httpd on --level 3 

Service State: Running
service httpd start 
```

Note: you know have +3 intelligence ;)


# Example 5: Install and maintain MYSQL configuration policy on company devservers
================================================================================
MYSQL Configuration Policy for CENTOS Development servers

Desired State is as follows:

```
Required dependency must execute first
yum update 

Required dependency must execute first
yum -y install mysql 

Package State: Installed
yum -y install mysql-server 

File Location: /root/instructions/my.cnf /etc/mysqld/
mv /root/instructions/my.cnf /etc/mysqld/my.cnf

File Perms State: 755
chown 755 /etc/mysqld/my.cnf 

Service State: Started upon system reboots
chkconfig mysqld on --level 3 

Service State: Running
service mysqld start 
```

John Rilling June 8, 2014
