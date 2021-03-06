#!/bin/bash
if [ "$1" == "setup" ] 
	then
		if [ "$2" == "ubuntu" ]
			then
			sudo apt update
			sudo apt install nginx
			sudo ufw allow 'Nginx HTTP'
			echo -n "Password ROOT MYSQL : "
			read password;
			sudo apt install mysql-server
			sudo mysql_secure_installation
			sudo mysql
			ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$password'; FLUSH PRIVILEGES; SELECT user,authentication_string,plugin,host FROM mysql.user;
			sudo apt install software-properties-common
			sudo add-apt-repository ppa:ondrej/php
			sudo apt install php8.0-fpm
			sudo apt install openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip
			sudo systemctl restart nginx
			
			echo "::: SETUP HAS BENN COMPLETED :::"
		elif [ "$2" == "centos" ]
			then
			echo "Cooming"
		else 
			sudo apt update
			sudo apt install nginx
			sudo ufw allow 'Nginx HTTP'
			echo -n "Password ROOT MYSQL : "
			read password;
			sudo apt install mysql-server
			sudo mysql_secure_installation
			sudo mysql
			ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$password'; FLUSH PRIVILEGES; SELECT user,authentication_string,plugin,host FROM mysql.user;
			sudo apt install software-properties-common
			sudo add-apt-repository ppa:ondrej/php
			sudo apt install php8.0-fpm
			sudo apt install openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip
			sudo systemctl restart nginx

			echo "::: SETUP HAS BENN COMPLETED :::"
		fi
elif [ "$1" == "bind" ]
	then
		cd /var/www/;
		echo "::: Make Sure Project Folder in /var/www/yourdomain.com/ :::"
		echo -n "Project Name : "; 
		read projectName; 
		mkdir "$projectName";
		sudo chown -R root:root /var/www/"$projectName";
		sudo touch /etc/nginx/sites-available/"$projectName".conf;
		if [ "$3" == "laravel" ]
			then
				echo 'server {
    listen 80 default_server;
    root /var/www/'"$projectName"'/public/;
    index index.php;
    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
            try_files $uri /index.php =404;
            fastcgi_pass unix:/var/run/php8.0-fpm.sock;
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            include fastcgi_params;
    }
}' >> /etc/nginx/sites-available/"$projectName".conf
		elif [ "$3" == "node" ]
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
}' >> /etc/nginx/sites-available/"$projectName".conf
		elif [ "$3" == "static" ]
			then
				echo 'server {
   root /var/www/'"$projectName"';
   index index.html index.htm;
   server_name '"$projectName"';

   location / {
       try_files $uri $uri/ =404;
   }
}' >> /etc/nginx/sites-available/"$projectName".conf
		fi
		sudo ln -s -f /etc/nginx/sites-available/"$projectName".conf /etc/nginx/sites-enabled/"$projectName".conf
		sudo systemctl restart nginx.service
		sudo apt update
		sudo apt install certbot
		sudo apt install python-certbot-nginx
		sudo certbot --nginx -d "$projectName"

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
