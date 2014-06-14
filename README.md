# Shell Technique
==============
### Shell based Configuration Management Framework
  
  
#### Summary:
Shell based configuration management framework using native Linux tools:
shell + cronjobs + revision control
  

#### Benefits:
1. Agentless - No daemon or installation of additional languages(Ruby Gems, Python modules, etc). 
2. Deployment phase: a single entry in a crontab file !
3. No version conflicts, no upgrades.
3. No wasted time learning abstract DSL languages. 
4. Radically reduced code set therefore less security risk.
6. Almost no CPU/RAM/Disk/Network/Backplane consumption.
7. Mean time to production (Minimal - ideal for continuous integration environments -"Warp 10 Scotty").
8. Leverages the "Lingua Franca" of all Linux admins/DevOps aka the shell.
9. Large scale deployment capability.
10. Simplicy is elegance AND power 
  

#### Architectural Overview: Simplicity is Elegance
1. Configure cron to pull and execute policies from your configuration management server.
2. Your done!!

Policies are simple shell scripts and associated config files representing the policies you want applied to your servers.
Anothe way to think of this is the state you want your server to consistently be in i.e packages installed, services running,
file permissions and ownership, etc. 

Lets get started with a simple example. 
###### Example 1: Apache Policy
In this example you will configure your server to pull a policy from our configuration management server. Specifically you will
configure your servers cron to pull an "apache web server policy" from our configuration management server. This policy
is a simple shell script named apache.sh and the associated config files. 


*Step 1:* Configure your server to sync policies with our configuration management server and then execute the apache.sh 
script every 15 mintues. Make the following entry in our servers crontab file:
```
ssh root@yourserver
yourserver# crontab -e
*/15 * * * * rsync -avzhe ssh example1@$ourserver:/policies /policies && /policies/apache/apache.sh 2>&1 >> /policies/apache/apache.sh.log
```

*Step 2:* Your done, verify it works!!
Lets start by examining the command we entered into our crontab:
"*/15" tells cron to execute the ensuring command every 15 minutes
" * * * *" tells cron to do it "Every day", "Every week", "Every month", "Every day of the month"
"rsync -avzhe ssh example1@$ourserver:/policies /policies" tells cron to copy the files located on our configuration managements servers 
"policies" directory to your servers /policies directory.

Because we are using Rysnc once the files are copied, everytime in the future this command is executed it will only tranfer any changes made 
to the files not the entire files again. In other words this is an extrememly efficient maner to syncronize policies between servers. We are also using ssh. This completely encrypts all data trasfered between our configuration management server and your local server. Very secure. 

*Verification:* Review /policies/apache/apache.sh.log for hints
Verification 1: Verify the "policies" directory and associated contents were transfered by rsync:
We do this by checking if their is a new directory named "policies" on your server. Inside that directory you should now see an apache.sh and an associated config file "httpd.conf"
```
ls -alrt /policies
```

*Verification 2:* Verify apache is installed:
yum search httpd


*Verification 3:* Verify apache configured to automatically start on system boot?
chkconfig --list

*Verification 4:* Verify you have a running apache server.
Use a command line tool like, curl, wget, lynx, links, nc etc. Here are some examples of how to check:
```
wget localhost:7777
curl localhost:7777
lynx localhost:7777
links localhost:7777
nc localhost 7777
```
You should also see an apache server process listed in your servers process table:
```
ps aux | grep httpd
netstat -plant | grep httpd
```

You should also see an httpd process listening on the 7777 port:
```
netstat -plant | grep 7777
```

##### Example 1 Summary:
You configured your server to syncornize an "apache policy" from our configuration management server. This was accomplished by
editing your servers crontab with a command to download the "/policies" directory and run the "apache.sh" script. Finally we
verfied the the "apache policy" was actually applied and succeded.

Extra Credit: Review the script used to configure apache on your server:
```
more /policies/apache/apache.sh
```

You will see the policy defines file permission and ownership, location, etc. Everything you need to apply policies to and maintain
state on your servers.





###### Example 2: mysql database Policy
In this example you will configure your server to pull an additional policy from our configuration management server. Specifically you will
configure your servers cron to pull the "mysql server policy" from our configuration management server. This policy
is a simple shell script named mysql.sh and the associated config files. At the end of this example you will have two polices maintained
on your server, the "apache" and "mysql" policies. Becuase we are going to install multiple policies and some policies may need to be
executed before others we will adjust our technique. This adjustment involves telling cron to execute a policy_manager.sh which will
in turn execute the apache.sh and mysql.sh policies. From this point forward cron will always use policy_manager.sh.

Step 1: Configure your server to sync policies with our configuration management server and then execute the policy_manager.sh 
script every 15 mintues. Make the following entry in our servers crontab file:
```
ssh root@yourserver
yourserver# crontab -e
*/15 * * * * rsync -avzhe ssh example1@$ourserver:/policies /policies && /policies/policy_manager.sh
```

You will notice you are syncing the "policies" directory on our configuration managment server to a policies directory on your server.
When the directories are synced a number of directories and files are downloaded including our original "/policies/apache/*",  the
new "/policies/mysql/*", and finally the "/policies/policy_manager.sh" script. 

"policy_manager.sh" script. The policy_manager.sh script is always executed first. It's role is siimilar to Linux "init" when the system
boots up. Only policy_manager.sh is used exclusively to manage the configuration policies we are applying to this server. Cron always
executes the policy_manager.sh which then executes all of the specific policy scipts i.e. apache.sh, mysql.sh. 

*Step 2:* Your done!! Verify it works.

*Verification:* Review:
```
/policies/apache/apache.sh.log for hints
/policies/mysql/mysql.sh.log for hints
/policies/policy_manager.sh.log for hints
```

*Verification 1:* Verify the "policies" directory and associated contents were transfered by rsync:
We do this by checking if their is a new directory named "policies" on your server. Inside that directory you should now see an apache.sh and an associated config file "httpd.conf"
```
ls -alrt /policies
```

*Verification 2:* Verify apache and mysql are installed:
yum search httpd
yum search mysql


*Verification 3:* Verify apache configured to automatically start on system boot?
chkconfig --list
chkconfig --list

*Verification 4:* Verify you have running apache and mysql servers.
APACHE
Use a command line tool like, curl, wget, lynx, links, nc etc. for apache:
```
wget localhost:7777
curl localhost:7777
lynx localhost:7777
links localhost:7777
nc localhost 7777
```
You should also see an apache server process listed in your servers process table:
```
ps aux | grep httpd
netstat -plant | grep httpd

MYSQL
Use the mysql client to connect to the server
mysql -h localhost -u root -p

You should also see a mysql server process listed in your servers process table:
```
ps aux | grep httpd
```

You should also see a mysql server process listening on port 8888
netstat -plant | grep mysql

##### Example 2 Summary:
You configured your server to syncornize an "apache policy" and a "MySQL" policy from our configuration management server. In addition 
we started using the "policy_manager.sh" script to manage the policies applied to the server. All of this was accomplished by
editing your servers crontab with a command to download the "/policies" directory and run the "policy_manager.sh" script. Finally we
verfied the the "apache" and "mysql" policies are actually applied to the system.

Extra Credit 1: Review the script used to configure mysql on your server:
```
more /policies/mysql/mysql.sh
```

You will see the policy defines file permission and ownership, location, etc. Everything you need to apply policies to and maintain
state on your servers.

Extra Credit 2: Review the "policy_manager.sh" script used to execute the apache and mysql policies:
```
more /policies/policy_manager.sh"
``` 


##### Example 3: Lets get serious, All your base are belong to us.
In most production corporate environments there is a "base" set of policies applied to most systems. The base of polices 
depend on the organization but here are some common ones:
```
repo_update.sh
repo.sh
ntp.sh
console.sh
sshd.sh
ldap.sh
sudo.sh
logrotate.sh
pam.sh
nsswitch.sh
postfix.sh
```



hn Rilling June 8, 2014*
