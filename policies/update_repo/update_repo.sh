### Desired System State is as follows:

```
# File Location: /policies/update_repo/companyrepo.repo /etc/yum.repos.d/
mv /policies/update_repo/companyrepo.repo /etc/yum.repos.d/

# File Perms: 644
chmod 644 /etc/yum.repos.d/companyrepo.repo

# File Ownership: root
chown root.root /etc/yum.repos.d/companyrepo.repo

# Action: Import REPO GPG key
rpm --import /root/instructions/RPM-GPG-KEY.txt /etc/path/to/mygpgkeys/

# File Ownership: root
chown root.root /etc/path/to/mygpgkeys/*

# File Perms: /etc/path/to/mygpgkeys/
chmod 600 /etc/path/to/mygpgkeys/*

# Action: Sync with REPO
yum update
```
