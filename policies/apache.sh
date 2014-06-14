Desired System State is as follows:

```
# Package State: Installed
yum -y install httpd

# File Location: /policies/httpd/httpd.conf /etc/httpd/
mv /policies/httpd/httpd.conf /etc/httpd/conf/httpd.conf

# File Perms State: 755
chown 755 /etc/httpd/conf/httpd.conf

# Service State: Started on system reboot
chkconfig httpd on --level 3

# Service State: Running
service httpd start
```

