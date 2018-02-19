
apt install -y php libapache2-mod-php php-mcrypt
curl https://raw.githubusercontent.com/jcd717/azure-vmss/master/install-linux-php/primes.php >/var/www/html/index.php
rm /var/www/html/index.html
