logs on the server:
    less /var/log/mongodb/mongod.log
    tail  -f  /home/dynamide/tomcat7/logs/catalina.out

ensure that full mongoClientURI is in place: 
    vi /home/dynamide/tomcat7/conf/server.xml
    mongoClientURI="mongodb://mongoSecurityRealmUser:Laramie33@localhost/security_realm"

