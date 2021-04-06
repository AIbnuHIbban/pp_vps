#!/bin/bash
# For Server
if [ "$1" == "setup" ] 
	then
		if [ "$2" == "ubuntu" ]
			then
				sudo apt update
				sudo apt install nginx
				sudo service nginx start
				sudo ufw allow 'Nginx HTTP'
				sudo ufw allow ssh
				sudo ufw allow 80
				sudo ufw allow 443
				echo -n "Password ROOT MYSQL : "
				read password;
				sudo apt install mysql-server
				sudo mysql_secure_installation
				sudo mysql
				sudo apt install software-properties-common
				sudo add-apt-repository ppa:ondrej/php
				sudo apt install php8.0-fpm
				sudo apt install openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip
				sudo systemctl restart nginx
				cd ~
				curl -sS https://getcomposer.org/installer -o composer-setup.php
				sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
				echo "::: SETUP HAS BEEN COMPLETED :::";
				echo "List Already Installed:";
				echo "1. Nginx";
				echo "2. MySQL";
				echo "3. PHP 8.0";
				echo "4. PHP Extension for Laravel";
				echo "5. Composer";
				echo "Thans for Using, -LeeNuksID";
		elif [ "$2" == "centos" ]
			then
				echo "Cooming";
		else 
			sudo apt update
			sudo apt install nginx
			sudo service nginx start
			sudo ufw allow 'Nginx HTTP'
			sudo ufw allow ssh
			sudo ufw allow 80
			sudo ufw allow 443
			echo -n "Password ROOT MYSQL : "
			read password;
			sudo apt install mysql-server
			sudo mysql_secure_installation
			sudo mysql
			sudo apt install software-properties-common
			sudo add-apt-repository ppa:ondrej/php
			sudo apt install php8.0-fpm
			sudo apt install openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip
			sudo systemctl restart nginx
			cd ~
			curl -sS https://getcomposer.org/installer -o composer-setup.php
			sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
			echo "::: SETUP HAS BEEN COMPLETED :::";
			echo "List Already Installed:";
			echo "1. Nginx";
			echo "2. MySQL";
			echo "3. PHP 8.0";
			echo "4. PHP Extension for Laravel";
			echo "5. Composer";
			echo "Thans for Using, -LeeNuksID";
		fi
elif [ "$1" == "bind" ]
	then
		cd /var/www/;
		echo "::: Make Sure Project Folder in /var/www/yourdomain.com/ :::"
		echo -n "Project Name : "; 
		read projectName; 
		sudo mkdir "$projectName";
		sudo touch /etc/nginx/sites-available/"$projectName".conf;
		if [ "$2" == "laravel" ]
			then
				echo 'server {
    server_name '"$projectName"';
    root /var/www/'"$projectName"'/public/;
    index index.php;
    
    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.0-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
}' | sudo tee -a /etc/nginx/sites-available/"$projectName".conf  > /dev/null
		cd /var/www/"$projectName";
		echo -n "URL Repository: "
		read repo;
		git clone "$repo" .;
		sudo chown -R www-data.www-data storage
		sudo chown -R www-data.www-data bootstrap/cache
		cp .env.example .env
		php artisan key:generate
		elif [ "$2" == "node" ]
			then
				echo -n "PORT : "
				read port;
				echo 'server {
    server_name '"$projectName"';
    location / {
        proxy_pass http://localhost:'"$port"';
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection upgrade;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}' | sudo tee -a /etc/nginx/sites-available/"$projectName".conf  > /dev/null
		elif [ "$2" == "static" ]
			then
				echo 'server {
   root /var/www/'"$projectName"';
   index index.html index.htm;
   server_name '"$projectName"';

   location / {
       try_files $uri $uri/ =404;
   }
}' | sudo tee -a /etc/nginx/sites-available/"$projectName".conf  > /dev/null
		fi
		sudo ln -s -f /etc/nginx/sites-available/"$projectName".conf /etc/nginx/sites-enabled/"$projectName".conf
		sudo systemctl restart nginx.service
elif [ "$1" == "--help" ]
	then
		echo 'Penggunaan : pp [OPTION] [SUB_OPTION] [ACTION:Optional]
OPTION LIST :

setup	
  SUB_OPTION: 
	ubuntu			Setup Configuration for Ubuntu
	centos			Setup Configuration for CentOS
bind
  SUB_OPTION: 
	laravel			Bind Domain to Laravel App
	node			Bind Domain to Node App
	static			Bind Domain to Static App'
fi
