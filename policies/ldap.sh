# Desired State is as follows:

```
# Package State: Installed
yum -y install openldap openldap-clients openldap-servers

# File Location: /policies/openldap/slapd.conf /etc/openldap/slapd.d/
mv /policies/openldap/slapd.conf /etc/openldap/slapd.d/

# File Perms: 600
chmod 600 /etc/openldap/slapd.d/*

# File Ownership: root
chown root.root /etc/openldap/slapd.d/*

# Service State: Start on boot
chkconfig slapd on --level 3

# Service Stage: On
service slapd start
```
