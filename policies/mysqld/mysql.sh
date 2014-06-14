# Desired system state is as follows:

# Required dependency must execute first
yum -y install mysql

# Package State: Installed
yum -y install mysql-server

# File Location: /policies/mysqld/my.cnf /etc/mysqld/
mv /policies/mysqld/my.cnf /etc/mysqld/my.cnf

# File Perms State: 755
chown 755 /etc/mysqld/my.cnf

# Service State: Started upon system reboots
chkconfig mysqld on --level 3

# Service State: Running
service mysqld start
```
