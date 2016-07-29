Create mongo database:
        cd ~/bin/mongodb
        ./shell -u $the_site_admin -p $the_site_admins_pw admin
        use votey       ##this line creates votey database, which you do as $the_site_admin.  You don't have query rights as $the_site_admin.
        
        db.createUser(
            {
              user: "bob",
              pwd: "MangoDog",
              roles: [
                 { role: "readWrite", db: "votey" }
              ]
            }
        )
        
        quit()
        
Set up dynamide app dispatch:
    vi ~/src/dynamide/src/assemblies/dynamide-apps/web-apps.xml
        
        
        
        
Securing Tomcat:
    check this file out when deploying--you will have to add that URL to tomcat proper, in order to get in.  In this file is a sample for /anarchia-admin, which you should clone for /votey-admin
        [vcrocla@SFCAML-G2XFD56] ~/src/dynamide/src/conf/tomcat/full-sample/build-tomcat-webapps-ROOT/web-inf/web.xml
