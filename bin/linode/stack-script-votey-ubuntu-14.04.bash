#!/bin/bash

set -x
echo "================  Boot log on `date` =========================" >> /root/stdout.txt
exec &>> /root/stdout.txt

##
## To use this script, delete the main disk, leave swap disk, and run 
##        stop server
##        delete "Ubuntu 14.1 disk"
##        linodes | # | Deploy an image | from stackscript  | "Anarchia Ubuntu 14.10, v15 script" | Edit | change version number | Save
##        linodes | # | Deploy an image | from stackscript  | "Anarchia Ubuntu 14.10, v20150508.6 script" (or later)
##        let it fill in 24064 MB in the create disk field.
##        enter root password.
##        after it finishes, boot this linode with the disk image just created.
##        See instructions if ssh keys are not in the webform: /Users/vcrocla/src/anarchia/doc/anarchia.workflow
##
## Laramie: TODO: allow much bigger swap disk size.
#
#FROM:  My ref: http://www.linode.com/?r=aadfce9845055011e00f0c6c9a5c01158c452deb

# <UDF name="notify_email" Label="Send email notification to" example="Email address to send notification and system alerts. Check Spam folder if you don't receive a notification within 6 minutes." default="order3@b-rant.com"/>
# <UDF name="user_name" default="laramie" label="Unprivileged user account name" example="This is the account that you will be using to log in." />

# <UDF default="ecotel33" name="user_password" label="Unprivileged user password" />
# <UDF default="ecotel33" name="dynamide_user_password" label="dynamide user password" />
# <UDF default="ecotel33" name="dm_tomcat_password" label="tomcat-users password" />
# <UDF default="" name="MONGO_REALM_PW" label="MongoRealm password" />


# <UDF name="user_sshkey" label="Public Key for user" default="" example="Recommended method of authentication." default="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzh9Xi2KGKCLB44j/KUn6D51pJO37uGIzKaLjmgrFnZUC6gpeqVtmr90tOaY7wIRvtttlo1kmCR9FXcY8Cac0nFmp5+ofoyQw0d/swcn6cuANW5ACAjHi0fEyMGNaH6dTk/EGRD1ACI9f5811tGQzUQzxrNf8x6I3nDErdK2U+NHgjCk6H4veWVefOgdl5ECCtBMwDFCx1lBorbinddz0FFutaJiIQzeqKNE6IGzBdwMRHkdrF7DJ+5wNmB/x6WScMH/rpVMGhfnYjai818qn1v5FWdmTr2gK3JEGjLE237wrrDqjIYG1Vt6YNYvvHrZg4hdOQvkpsia+hDOm/q1Zp order3@b-rant.com" />
# <UDF name="dynamide_sshkey" label="Public Key for user dynamide" default="" example="Recommended method of authentication." default="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzh9Xi2KGKCLB44j/KUn6D51pJO37uGIzKaLjmgrFnZUC6gpeqVtmr90tOaY7wIRvtttlo1kmCR9FXcY8Cac0nFmp5+ofoyQw0d/swcn6cuANW5ACAjHi0fEyMGNaH6dTk/EGRD1ACI9f5811tGQzUQzxrNf8x6I3nDErdK2U+NHgjCk6H4veWVefOgdl5ECCtBMwDFCx1lBorbinddz0FFutaJiIQzeqKNE6IGzBdwMRHkdrF7DJ+5wNmB/x6WScMH/rpVMGhfnYjai818qn1v5FWdmTr2gK3JEGjLE237wrrDqjIYG1Vt6YNYvvHrZg4hdOQvkpsia+hDOm/q1Zp order3@b-rant.com" />
# <UDF name="sshd_passwordauth" label="Use SSH password authentication" oneof="Yes,No" default="No" example="Turn off password authentication if you have added a Public Key." />
# <UDF name="sshd_permitrootlogin" label="Permit SSH root login" oneof="No,Yes" default="No" example="Root account should not be exposed." />

# <UDF name="user_shell" label="Shell" oneof="/bin/zsh,/bin/bash" default="/bin/bash" />

# <UDF name="sys_hostname" label="System hostname" default="li257-17.members.linode.com" example="Name of your server, i.e. web1.anarchia.us" />

# <UDF name="setup_mongodb" label="Install MongoDB" oneof="Yes,No" default="Yes" />

## Disks:  512MB Swap Image (512 MB, swap), Ubuntu 14.1 disk (24064 MB, ext4)

set -e
set -u
#set -x

USER_GROUPS=sudo

exec &> /root/stackscript.log

## You can view StackScript ID 1 here: https://www.linode.com/stackscripts/view/1
source <ssinclude StackScriptID="1"> # StackScript Bash Library
system_update

source <ssinclude StackScriptID="36985"> # lib-system was 124
system_install_mercurial
system_start_etc_dir_versioning #start recording changes of /etc config files

# Configure system
source <ssinclude StackScriptID="36986"> # lib-system-ubuntu was 123
system_update_hostname "$SYS_HOSTNAME"
system_record_etc_dir_changes "Updated hostname" # SS124

# Create user account
system_add_user "$USER_NAME" "$USER_PASSWORD" "$USER_GROUPS" "$USER_SHELL"
if [ "$USER_SSHKEY" ]; then
    system_user_add_ssh_key "$USER_NAME" "$USER_SSHKEY"
fi
system_record_etc_dir_changes "Added unprivileged user account" # SS124



# Configure sshd
system_sshd_permitrootlogin "$SSHD_PERMITROOTLOGIN"
system_sshd_passwordauthentication "$SSHD_PASSWORDAUTH"
touch /tmp/restart-ssh
system_record_etc_dir_changes "Configured sshd" # SS124

# Lock user account if not used for login
if [ "SSHD_PERMITROOTLOGIN" == "No" ]; then
    system_lock_user "root"
    system_record_etc_dir_changes "Locked root account" # SS124
fi

# Install Postfix
postfix_install_loopback_only # SS1
system_record_etc_dir_changes "Installed postfix loopback" # SS124

# Setup logcheck
system_security_logcheck
system_record_etc_dir_changes "Installed logcheck" # SS124

# Setup fail2ban
system_security_fail2ban
system_record_etc_dir_changes "Installed fail2ban" # SS124

# Setup firewall
system_security_ufw_configure_basic
system_record_etc_dir_changes "Configured UFW" # SS124

source <ssinclude StackScriptID="36987"> # lib-python was 126
python_install
system_record_etc_dir_changes "Installed python" # SS124

# lib-system - SS124
system_install_utils
system_install_build
system_install_subversion
system_install_git
system_record_etc_dir_changes "Installed common utils"

# Install MongoDB
if [ "$SETUP_MONGODB" == "Yes" ]; then
    ##source <ssinclude StackScriptID="36988"> # lib-mongodb was 128
    ##mongodb_install
    
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
    echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
    apt-get update
    apt-get install -y mongodb-org=2.6.9 mongodb-org-server=2.6.9 mongodb-org-shell=2.6.9 mongodb-org-mongos=2.6.9 mongodb-org-tools=2.6.9

    system_record_etc_dir_changes "Installed MongoDB"
fi

#for root:
pushd /root
git clone https://github.com/dynamide/bash-menu.git .bash-menu
echo 'source ~/.bash-menu/.bash_profile' >> /root/.bash_profile
popd

## BEGIN dynamide   ==================================================================
    
    ufw allow 8080
    
    ##20160805 no longer available on 14.04: apt-get -y install openjdk-8-jdk
    apt-get -y install openjdk-7-jdk
    apt-get -y -u install ant
    
    pushd /home/$USER_NAME
    git clone https://github.com/dynamide/bash-menu.git .bash-menu
    echo 'source ~/.bash-menu/.bash_profile' >> /home/$USER_NAME/.bash_profile
    chown -R $USER_NAME:$USER_NAME .bash-menu
    popd

    
    groupadd anarchia      #so that dynamide doesn't have to be in sudo group.
    # Create user account
    system_add_user "dynamide" "$DYNAMIDE_USER_PASSWORD" "anarchia" "/bin/bash"
    system_record_etc_dir_changes "Added unprivileged user account: dynamide"
    
    if [ "$DYNAMIDE_SSHKEY" ]; then
        system_user_add_ssh_key "dynamide" "$DYNAMIDE_SSHKEY"
    fi
    
    ## let your admin user be in these two groups for ease.
    usermod -G dynamide,anarchia,$USER_NAME $USER_NAME
    
    ## Not doing it here, but you can do this on the box for anyone who deserves it:
    ##  usermod -a -G sudo laramie
    
    #check logins: "id laramie" or "id root"
    
    
    pushd /home/dynamide
        git clone https://github.com/dynamide/dynamide.git
        chown -R dynamide:anarchia dynamide
        
        git clone https://github.com/dynamide/bash-menu.git .bash-menu
        echo 'source ~/.bash-menu/.bash_profile; export DYNAMIDE_HOME=/home/dynamide/dynamide' >> /home/dynamide/.bash_profile
        chown -R dynamide:anarchia .bash-menu
    
        ##wget http://mirrors.koehn.com/apache/tomcat/tomcat-7/v7.0.59/bin/apache-tomcat-7.0.59.tar.gz
        ##wget http://mirrors.sonic.net/apache/tomcat/tomcat-7/v7.0.63/bin/apache-tomcat-7.0.63.tar.gz
        wget http://mirrors.sonic.net/apache/tomcat/tomcat-7/v7.0.70/bin/apache-tomcat-7.0.70.tar.gz
        tar xvfz apache-tomcat-7.0.70.tar.gz
        mv apache-tomcat-7.0.70 tomcat7
        chown -R dynamide:anarchia ./tomcat7
        
        rm -rf /home/dynamide/tomcat7/webapps/ROOT    ## we use conf/Catalina/localhost/ROOT.xml instead.
        rm -rf /home/dynamide/tomcat7/webapps         ## It will recreate this directory on startup, but the examples, docs, and manager will be safely gone.    
        
############# here-doc: config tomcat as dynamide ##############################
su dynamide <<'EOF'
        sed -i.bak \
            -e's/DM_TOMCAT_HOME=.*$/DM_TOMCAT_HOME=\/home\/dynamide\/tomcat7/g' \
            /home/dynamide/dynamide/dynamide.local.properties
        
        pushd /home/dynamide/dynamide
            ant
            cp /home/dynamide/dynamide/src/conf/tomcat/ubuntu-14.10-init.d-tomcat7-as-dynamide /home/dynamide/tomcat7.sh
            mkdir /home/dynamide/pids
            chmod a+w /home/dynamide/pids
            touch $CATALINA_BASE/work/catalina.policy
            cp /home/dynamide/dynamide/src/conf/server.xml /home/dynamide/tomcat7/conf/
        popd
        
        ## In theory, you could encript the db password itself using something like this: http://www.jdev.it/encrypting-passwords-in-tomcat/
        
        cp /home/dynamide/dynamide/lib/mongo-realm-1.0-SNAPSHOT.jar /home/dynamide/tomcat7/lib/
        cp /home/dynamide/dynamide/lib/mongo-java-driver-2.13.0-rc1.jar /home/dynamide/tomcat7/lib/
        
EOF
############# END here-doc #####################################################

## Now change pw as root, but leave file ownership as dynamide.
sed -i.bak \
    -e's/mongoClientURI="[^"]*"/mongoClientURI="mongodb:\/\/mongoSecurityRealmUser:'"$MONGO_REALM_PW"'@localhost\/security_realm"/g' \
    /home/dynamide/tomcat7/conf/server.xml





        
    
############# here-doc: talk to mongo ##########################################
su dynamide <<'EOF'
        mongo
        use admin
        db.createUser(
          {
            user: "siteUserAdmin",
            pwd: "MangoDog33",
            roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
          }
        )
        use anarchia
        db.createUser(
            {
              user: "bob",
              pwd: "MangoDog",
              roles: [
                 { role: "read", db: "test" },
                 { role: "readWrite", db: "anarchia" }
              ]
            }
        )
        use security_realm
        db.createUser(
            {
              user: "mongoSecurityRealmUser",
              pwd: "Laramie33",
              roles: [
                 { role: "readWrite", db: "security_realm" }
              ]
            }
        )
        use security_realm
        db.user.insert( { username: "laramie", credentials: "0ba62cf830bc75ecccd23e8e46a268d3e0234c42a99edada4fee34e050d8cb54", roles: [ { name: "dynamide-admin" },{ name: "dynamide-user" },{ name: "anarchia-author" } ] } );
        db.user.insert( { username: "cooper", credentials: "ddb7e26d8cff4873aa8feb25554769efe352bcb838ddf050a13967d6127a05fc", roles: [ { name: "dynamide-user" },{ name: "anarchia-author" } ] } );
        db.user.insert( { username: "rusty", credentials: "61c06f5bf942c489c9c2394f5eafcf5af83b17ea0861e33f67a8af84f09c6693", roles: [ { name: "anarchia-user" } ] } );
        
EOF
############# END here-doc #####################################################

        #mongo 2.6.9 changed conf name to mongod.conf from mongodb.conf and service mongodb ==> service mongod
        sed -i.bak \
            -e's/^\#auth = true/auth=true/g' \
            /etc/mongod.conf
        
        service mongod restart
            
    popd
    
    #cp /home/dynamide/dynamide/src/conf/tomcat/ubuntu-14.10-init.d-tomcat7 /etc/init.d/tomcat7
    cp /home/dynamide/dynamide/src/conf/tomcat/ubuntu-14.10-init.d-tomcat7-as-root /etc/init.d/tomcat7
    

    chmod 755 /etc/init.d/tomcat7
    update-rc.d tomcat7 defaults
    
    /etc/init.d/tomcat7 start
    
    #Now set up nginx:

    apt-get -y install nginx
    
    mkdir /etc/nginx/ssl
    if [ -f /etc/nginx/sites-enabled/default ]; then
        rm /etc/nginx/sites-enabled/default
    fi


############# here-doc: create nginx server block ##############################
cat <<"EOF" > /etc/nginx/sites-enabled/anarchia.us
        server {
                listen 80 default_server;
                listen [::]:80 default_server ipv6only=on;
                listen 443 ssl;
                root /usr/share/nginx/html;
                index index.html index.htm;
                server_name li257-17.members.linode.com;
                ssl_certificate /etc/nginx/ssl/nginx.crt;
                ssl_certificate_key /etc/nginx/ssl/nginx.key;
                location / {
                        proxy_set_header X-Real-IP $remote_addr;
                        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                        proxy_set_header Host $host;
                        proxy_set_header X-NginX-Proxy true;
                        proxy_pass http://127.0.0.1:8080;
                        proxy_redirect http://127.0.0.1:8080/ https://$server_name/;
                }
        }
EOF
############# END here-doc #####################################################



    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
       -keyout /etc/nginx/ssl/nginx.key \
       -out /etc/nginx/ssl/nginx.crt \
       -subj '/CN=li257-17.members.linode.com/O=anarchia.us/C=US'

    service nginx restart

    
## END dynamide  ===============================================================

restart_services
restart_initd_services


####You may want to set up Monit: ...ssinclude StackScriptID="130"... # lib-monit

# Send info message
cat > ~/setup_message <<EOD
Hi,

Your Linode VPS configuration is completed.

EOD
RDNS=$(get_rdns_primary_ip)
cat >> ~/setup_message <<EOD
To access your server ssh to $USER_NAME@$RDNS
EOD

mail -s "Your Linode VPS is ready" "$NOTIFY_EMAIL" < ~/setup_message

