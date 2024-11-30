#!/bin/bash

# Function to install Golang with selected version
install_golang() {
    while true; do
        GO_VERSION=$1
        wget https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
        if [ $? -eq 0 ]; then
            sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
            echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc
            source ~/.bashrc
            rm go${GO_VERSION}.linux-amd64.tar.gz
            if go version | grep -q "go${GO_VERSION}"; then
                break
            else
                echo "Failed to install Golang. Please try again."
            fi
        else
            echo "Failed to download Golang. Please try again."
        fi
        echo -n "Select Golang version to install (e.g., 1.15.6): "
        read GO_VERSION
    done
}

# Function to install PHP with selected version
install_php() {
    while true; do
        PHP_VERSION=$1
		sudo apt install software-properties-common
		sudo add-apt-repository ppa:ondrej/php
        sudo apt install -y php${PHP_VERSION}-fpm
        if [ $? -eq 0 ]; then
            sudo apt install -y openssl php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-json php${PHP_VERSION}-mbstring php${PHP_VERSION}-mysql php${PHP_VERSION}-xml php${PHP_VERSION}-zip php${PHP_VERSION}-gd
            if [ $? -eq 0 ]; then
                break
            else
                echo "Failed to install PHP extensions. Please try again."
            fi
        else
            echo "Failed to install PHP. Please try again."
        fi
        echo -n "Select PHP version to install (7.x - 8.x): "
        read PHP_VERSION
    done
}


# Function to install selected database
install_database() {
    DB=$1
    if [ "$DB" == "mysql" ]; then
        echo -n "Password ROOT MYSQL : "
        read password;
        sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $password"
        sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $password"
        sudo apt install -y mysql-server
        sudo mysql_secure_installation
    elif [ "$DB" == "mariadb" ]; then
        sudo apt install -y mariadb-server
    elif [ "$DB" == "postgresql" ]; then
        sudo apt install -y postgresql
    fi
}


if [ "$1" == "test" ] 
	then
		echo "Bash PP Ready to Use";
elif [ "$1" == "ip" ] 
	then
		curl ifconfig.me
elif [ "$1" == "ssl" ]
	then
 		echo -n "Masukkan nama domain: "
		read nama_domain
		sudo certbot --nginx -d "$nama_domain"
elif [ "$1" == "install" ]
	then
		case $2 in
			golang)
				install_golang $3
				;;
			php)
				install_php $3
				;;
			nginx)
				sudo apt update
				sudo apt install -y nginx
				;;
			composer)
				cd ~
				curl -sS https://getcomposer.org/installer -o composer-setup.php
				sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
				sudo rm -rf composer-setup.php
				;;
			node)
				curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
				sudo apt-get install -y nodejs
				;;
			mysql)
				install_database mysql
				;;
			mariadb)
				install_database mariadb
				;;
			postgresql)
				install_database postgresql
				;;
			help)
				echo "Usage: $0 COMMAND"
				echo
				echo "Commands:"
				echo "  install golang [version]    Install Golang with the specified version"
				echo "  install php [version]       Install PHP with the specified version"
				echo "  install nginx               Install Nginx"
				echo "  install composer            Install Composer"
				echo "  install node                Install Node.js"
				echo "  install mysql               Install MySQL"
				echo "  install mariadb             Install MariaDB"
				echo "  install postgresql          Install PostgreSQL"
				echo "  --help, -h                  Show this help message"
				exit 0
				;;
			*)
				echo "Invalid option $2"
				;;
		esac
elif [ "$1" == "setup" ] 
	then
		if [ "$2" == "ubuntu" ]
			then
				sudo apt update
				sudo timedatectl set-timezone Asia/Jakarta
				sudo apt install -y nginx
				sudo service nginx start
				sudo ufw allow 'Nginx HTTP'
				sudo ufw allow ssh
				sudo ufw allow 80
				sudo ufw allow 443

				echo -n "Do you want to install Golang? (yes/no): "
				read install_golang_answer
				if [ "$install_golang_answer" == "yes" ]; then
				    echo -n "Select Golang version to install (e.g., 1.17.13, 1.16, 1.15.6): "
				    read go_version
				    install_golang $go_version
				fi
		
				echo -n "Select database to install (mysql, mariadb, postgresql): "
				read db;
				install_database $db
		
				echo -n "Select PHP version to install (7.x - 8.x): "
				read php_version;
				install_php $php_version
		
				sudo systemctl restart nginx
		
				cd ~
				curl -sS https://getcomposer.org/installer -o composer-setup.php
				sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
				sudo rm -rf composer-setup.php
		
				echo "::: SETUP HAS BEEN COMPLETED :::";
				echo "List Already Installed:";
				echo "1. Nginx";
				echo "2. $db";
				echo "3. PHP $php_version";
				echo "4. PHP Extension for Laravel";
				echo "5. Composer";
				echo "Thanks for Using, -LeeNuksID";
		elif [ "$2" == "debian" ]
			then
				sudo timedatectl set-timezone Asia/Jakarta
				sudo apt install wget
				sudo apt install nginx
				sudo service nginx start
				sudo ufw allow 'Nginx HTTP'
				sudo ufw allow ssh
				sudo ufw allow 80
				sudo ufw allow 443
				echo -n "Password ROOT MYSQL : "
				read password;
				sudo apt install mariadb-server
				sudo mysql_secure_installation
				sudo mariadb
				sudo apt install -y lsb-release ca-certificates apt-transport-https software-properties-common
				echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/sury-php.list
				sudo wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg 
				sudo apt update
				sudo apt install php8.0-fpm
				sudo apt install openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip php-gd
				sudo systemctl restart nginx
				cd ~
				curl -sS https://getcomposer.org/installer -o composer-setup.php
				sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
				sudo rm -rf composer-setup.php
				echo "::: SETUP HAS BEEN COMPLETED :::";
				echo "List Already Installed:";
				echo "1. Nginx";
				echo "2. MariaDB";
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
		cd /var/www/
		echo "::: Make Sure Project Folder in /var/www/yourdomain.com/ :::"
		echo -n "Project Name : "
		read projectName
		
		# Cek folder
		if [ -d "$projectName" ]; then
		    echo "Folder $projectName sudah ada. Replace (y/n)?"
		    read replace_folder
		    if [ "$replace_folder" == "y" ]; then
		        sudo rm -rf "$projectName"
		    else
		        echo "Ganti nama folder: "
		        read projectName
		    fi
		fi
		sudo mkdir "$projectName"
		
		# Cek file konfigurasi Nginx
		nginx_config="/etc/nginx/sites-available/$projectName.conf"
		if [ -f "$nginx_config" ]; then
		    echo "File konfigurasi $nginx_config sudah ada. Replace (y/n)?"
		    read replace_file
		    if [ "$replace_file" == "y" ]; then
		        sudo rm -f "$nginx_config"
		    else
		        echo "Ganti nama file: "
		        read projectName
		        nginx_config="/etc/nginx/sites-available/$projectName.conf"
		    fi
		fi
		sudo touch "$nginx_config"
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
}' | sudo tee -a /etc/nginx/sites-available/"$projectName".conf  > /dev/null;
		cd /var/www/"$projectName";
		echo -n "URL Repository: ";ls
		read repo;
		sudo git clone "$repo" .;
  		sudo git config credential.helper store;
  		sudo chmod 755 -R /var/www/"$projectName";
		sudo chown -R www-data.www-data storage;
		sudo chown -R www-data.www-data bootstrap/cache;
		sudo cp .env.example .env;
		sudo composer install;
		php artisan key:generate;
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
elif [ "$1" == "nginx" ]; then
    echo -n "Domain yang ingin dibind: "
    read domain_name

    # Buat folder di /var/www sesuai dengan domain
    project_path="/var/www/$domain_name"
    if [ -d "$project_path" ]; then
        echo "Folder untuk $domain_name sudah ada."
    else
        sudo mkdir -p "$project_path"
        echo "Folder $domain_name telah dibuat di $project_path."
    fi

    # Buat file konfigurasi Nginx
    nginx_config="/etc/nginx/sites-available/$domain_name.conf"
    if [ -f "$nginx_config" ]; then
        echo "Konfigurasi untuk $domain_name sudah ada."
    else
        echo "Membuat konfigurasi Nginx untuk $domain_name..."
        sudo bash -c "cat > $nginx_config <<EOL
server {
    server_name $domain_name;
    root $project_path;

    index index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    error_page 404 /404.html;
    location = /404.html {
        root $project_path;
    }
}
EOL"
        echo "Konfigurasi Nginx untuk $domain_name telah dibuat."
    fi

    # Buat symlink ke sites-enabled
    sudo ln -sf $nginx_config /etc/nginx/sites-enabled/

    # Restart Nginx
    echo "Restarting Nginx..."
    sudo systemctl restart nginx

    echo "Domain $domain_name telah dibind ke Nginx dan aktif."
elif [ "$1" == "mysql" ]
	then
		echo -n "Megacerbon290901!" | pbcopy
		mysql -u root -p
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
