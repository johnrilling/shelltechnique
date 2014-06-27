```
## SHELL TECHNIQUE
==============
# Shell based Configuration Management Framework


## SUMMARY:
# Shell based configuration management framework using native Linux tools:
# shell + cronjobs + revision control


## BENEFITS:
# 1. Agentless - No daemon or languages install reqs (Ruby, Perl, Python, etc).

# 2. Minimal deployment time: a single entry in a crontab file !

# 3. No version conflicts or no upgrades.

# 4. No wasted time learning abstract DSL languages.

# 5. Radically reduced code set therefore less security risk.

# 6. Minimal CPU, RAM, disk, network, or back-plane consumption.

# 7. Leverages the "Lingua Franca" of all Linux admins/DevOps aka the shell.

# 8. Large scale deployment capability.

# 9. Simplicity is elegance AND power


## Architectural Overview: Simplicity is Elegance
# 1. Configure cron to pull and execute policies from your configuration management server.

# 2. Your done!!

# Policies are simple shell scripts and associated config files representing the policies you want applied to your servers. Another way to think of this is the state you want your server to consistently be in i.e. packages installed, services running, file permissions and ownership, etc.


## Example 1: Download policies - Apache Policy
In this example you will configure your server to pull a policy from our configuration management server. Specifically you will configure your servers cron to download all policies associated with your server. These policies are simple shell scripts and associated config files. We include a “policy_manager.sh” script to govern the policy execution on your system. Think of it as the “init” of policy management.

# Step 1: Configure your server to download policies for your server from our configuration management server. Your server will then execute and re-sync policies every 15 minutes. Perform the following:

# Connect to your server
ssh root@yourserver

# Edit your servers crontab to contain the following:
crontab -e
*/15 * * * * rsync -avzhe ssh example1@$ourserver:/policies/example-1/* /policies && /policies/policy_manager.sh 2>&1 >> /policies/policy_manager.log

# Step 2: Your done, verify it works!!


# Lets examine the command we entered into our crontab:
# “*/15” tells cron to execute the ensuing command every 15 minutes

# ”* * *” tells cron to do it "Every day", "Every week", "Every month", "Every day of the month"

# “rsync -avzhe ssh example1@$ourserver:/policies/example-1/* /policies” tells cron to copy the files located on our configuration managements servers "/policies/example-1" directory to your servers /policies directory.

# NOTES: 
# Using rysnc enables us to only transfer changes made to existing files rather than downloading the entire directory contents repeatedly. In other words this is an extremely efficient manner to synchronize policies between servers. Using ssh completely encrypts all data transferred between our configuration management server and your local server. Very secure. 

# Example 1 Verification:
# You should now see a newly created "/policies" directory on your server with the following contents:
/policies/policy_manager.sh
/policies/policy_manager.log 
/policies/apache/apache.sh 
/policies/apache/httpd.conf 

# Verify apache is installed:
yum search httpd

# Verify apache configured to automatically start on system boot?
chkconfig –list httpd

# Verify you have a running apache server.
# Use a command line tool like, curl, wget, lynx, links, nc etc. Here are some examples of how to check:
wget localhost:7777
curl localhost:7777
lynx localhost:7777
links localhost:7777
nc localhost 7777

# Verify you see an apache server process listed in your servers process table:
ps aux | grep httpd

# Verify you see apache aka httpd listening on port 51500
netstat -plant | grep 51500

# Conclusion Example 1:
# You configured your server to synchronize policies from our configuration management server. This was accomplished by including a command in your servers crontab which downloads the "/policies/example-1" directory and runs the "policy_manager.sh" script. This script execute all the policies applied to your system. In this case it was the apache.sh policy script accompanied by the associated httpd.conf configuration file. 

# Extra Credit: Review the script used to configure apache on your server:
more /policies/apache/apache.sh

# You will see the policy defines file permission and ownership, location, etc. Everything you need to apply policies to and maintain state on your servers.



## Example 2: Download policies - MYSQL Policy
In this example you will configure your server to pull a policy from our configuration management server. Specifically you will configure your servers cron to download all policies associated with your server. These policies are simple shell scripts and associated config files. We include a “policy_manager.sh” script to govern the policy execution on your system. Think of it as the “init” of policy management.

# Step 1: Configure your server to download policies for your server from our configuration management server. Your server will then execute and re-sync policies every 15 minutes. Perform the following:

# Connect to your server
ssh root@yourserver

# Edit your servers crontab to contain the following:
crontab -e
*/15 * * * * rsync -avzhe ssh example1@$ourserver:/policies/example-2/* /policies && /policies/policy_manager.sh 2>&1 >> /policies/policy_manager.log

# Step 2: Your done, verify it works!!


# Lets examine the command we entered into our crontab:
# “*/15” tells cron to execute the ensuing command every 15 minutes

# ”* * *” tells cron to do it "Every day", "Every week", "Every month", "Every day of the month"

# “rsync -avzhe ssh example1@$ourserver:/policies/example-2/* /policies” tells cron to copy the files located on our configuration managements servers "/policies/example-2" directory to your servers /policies directory.

# NOTES: 
# Using rysnc enables us to only transfer changes made to existing files rather than downloading the entire directory contents repeatedly. In other words this is an extremely efficient manner to synchronize policies between servers. Using ssh completely encrypts all data transferred between our configuration management server and your local server. Very secure. 

# Example 2 Verification:
# You should now see a newly created "/policies" directory on your server with the following contents:
/policies/policy_manager.sh
/policies/policy_manager.log 
/policies/mysql/mysql.sh 
/policies/mysql/my.cnf 

# Verify MYSQL is installed:
yum search mysqld

# Verify mysql configured to automatically start on system boot?
chkconfig –list mysqld

# Verify you have a running mysql server.
# Use the mysql client command line tool:
mysql -u root -h localhost -p
mysql>

# Verify you see a mysql server process listed in your servers process table:
ps aux | grep mysqld

# Verify you see apache aka httpd listening on port 3306
netstat -plant | grep 3306

# Conclusion Example 2:
# You configured your server to synchronize policies from our configuration management server. This was accomplished by including a command in your servers crontab which downloads the "/policies/example-2" directory and runs the "policy_manager.sh" script. This script execute all the policies applied to your system. In this case it was the mysql.sh policy script accompanied by the associated my.cnf configuration file. 

# Extra Credit: Review the script used to configure apache on your server:
more /policies/mysql/mysql.sh

# You will see the policy defines file permission and ownership, location, etc. Everything you need to apply policies to and maintain state on your servers.



John Rilling June 8, 2014*
```

