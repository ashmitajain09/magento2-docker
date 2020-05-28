# Mag-Docker
##### Installs magento2.3.5 prerequisites.
Docker images used:
```
arunkp03/mariadb-10.4.12:v1
arunkp03/apache2.4.18-php7.2.5-magento2.3.5:v1
```
___
### Installation steps
```
$ git clone https://github.com/arunkp123/mag-docker.git docker-magento2
$ cd docker-magento2
$ sh setup.sh
```
```Note: In the above command, you can replace [docker-magento2] with directory name you want for the project to be cloned to.```

Once this setup is completed, go to terminal and enter below command to check if the docker containers are ready

```
$ docker ps
```
![N|Solid](https://api.arunkp.in/media/docker-ps.png)
Containers created: 
```
web
mysql
phpmyadmin
 ```
### Magento2.3.5 installation on the ```web``` container
From a new terminal tab enter below command to move into the web container to access the linux box
```
$ docker exec -it web bash
```
You will enter into web container linux box at ```/var/www/html/```
Now run below commands
```
$ cd public
$ composer create-project--repository-url=https://repo.magento.com/magento/project-community-edition magento
```
You will be asked for ```username```/```password``` after above command.
Username/password is basically the ```publicKey```/```privateKey``` which is available or you may need to create one here: https://marketplace.magento.com/customer/accessKeys/ .

After you enter the username and password, composer will install all the package dependencies for magento2.
Once done, run below command

```
$ php bin/magento setup:install --admin-firstname=Admin --admin-lastname=User --admin-email=test@test.com --admin-user=admin --admin-password=Passw0rd@123 --base-url=http://local.magento.com --base-url-secure=https://local.magento.com --backend-frontname=admin --db-host=mysql --db-name=magento --db-user=root --db-password=root --use-rewrites=1 --language=en_US --currency=USD --timezone=America/New_York --use-secure-admin=1 --admin-use-security-key=1 --session-save=files --use-sample-data
````
You may change the below variable values in the above command:
```
admin-firstname
admin-lastname
admin-email
admin-user
admin-password
base-url
base-url-secure
```
Once this is successfully done, it's time to install the sample data if you need or you may skip this command.

```php bin/magento sampledata:deploy```

After all the above steps its time to clear all the cache:
```
$ php bin/magento cache:flush
$ php bin/magento cache:clean
```
It's time now to make apache access our magento project at some domain:
```
$ vi /etc/apache2/sites-enabled/000-default.conf
```
Replace below in the above file
```
<VirtualHost *:80>
        ServerName local.magento.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/public/magento
        <Directory /var/www/html/public/magento>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride All
                Require all granted
        </Directory>
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        <FilesMatch "(mobingi-init\.sh$|mobingi-install\.sh$)">
                Require all denied
        </FilesMatch>
</VirtualHost>
```
In the above configuration you may need to replace value of `ServerName` with the value defined in `base-url` in the *php bin/magento setup:install*  command if you changed it there.

Restart apache: 
```
$ service apache2 restart
```
You may now exit from the web container with `exit` command.
Now add the ServerName to the system hosts file:
1. In mac `/etc/hosts` add below line:
  ` 
   127.0.0.1 local.magento.com 
   `
2. In windows, open `c:\windows\system32\drivers\etc\hosts` with administrator permission and add below line:
`127.0.0.1 local.magento.com`

Now you should be able to access your site on `http://local.magento.com` and admin section can be accessed using `http://local.magento.com/admin`

I hope this guide helped you to setup magento2 smoothly on your machine. 
#### Thanks for trying this! ####
