## Setup RDS Mysql and Install wordpress

1. Create RDS Mysql Database with database name : ```wordpress```
2. Create Webserver EC2 instance
3. Install Apache and dependencies
```bash
sudo apt install apache2 libapache2-mod-php php-mysql
```
4. Download wordpress and copy to ```/var/www```
[Download from here](https://wordpress.org/download/)
5. extract and copy the extract folder to ```/var/www```
```bash
wget https://wordpress.org/latest.zip
# sudo apt install zip -y
unzip latest.zip
mv wordpress /var/www

```
6. Move apache site configuration
```bash
cd /var/www/wordpress
sudo mv 000-default.conf /etc/apache2/sites-enabled/
```

7. Restart apache
```bash
sudo apache2ctl restart
```

### Configure wordpress
1. Update db connection string
```bash
cd /var/www/wordpress
sudo vi wp-config.php
```

```bash
define('DB_HOST', 'localhost');
```to 
```bash
define('DB_HOST', '<INSERT ENDPOINT HERE>');
```
### Complete wordpress installation using workdpress initial configuration ui.

