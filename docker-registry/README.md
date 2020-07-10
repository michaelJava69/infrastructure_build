README

links

https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-18-04
https://icicimov.github.io/blog/docker/Docker-Private-Registry-with-S3-backend-on-AWS/
https://github.com/cirocosta/sample-docker-registry-aws




MAC Users

Rem

docker-machine start
eval $(docker-machine env default)


Pre-requisites
--------------

```
Create an Ubuntu ec2 (free tier size will do) i.e tag Docker-registry
ssh onto the ec2 docker-reghistry box

install docker : https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-18-04
--------------
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce

Check that it’s running:

sudo systemctl status docker



See  s3 buckets folder for README.md


```



 
```
install nginx

After the regitry installed and linked to S3 bucket  (terraform)


sudo apt update
sudo apt install nginx


systemctl status nginx.    # just a check
 

Check access to nginx server 
—————————————---------------- 

Add rules to instance to open up port 80 and port 443


Server blocks
———————

bought/registered domain (mydocker.ga)  and created A-record  : register.mydocker.ga (pointing at ec2 instance hosting)

sudo mkdir -p /var/www/terraform.mydocker.ga/html

sudo chown -R $USER:$USER /var/www/terraform.mydocker.ga/html

sudo chmod -R 755 /var/www/terraform.mydocker.ga



Testing
-------


nano /var/www/terraform.mydocker.ga/html/index.html

<html>
    <head>
        <title>Welcome to terraform.mydocker.ga!</title>
    </head>
    <body>
        <h1>Success!  The terraform.mydocker.ga server block is working!</h1>
    </body>
</html>

	
sudo nano /etc/nginx/sites-available/terraform.mydocker.ga


server {
        listen 80;
        listen [::]:80;

        root /var/www/terraform.mydocker.ga/html;
        index index.html index.htm index.nginx-debian.html;

        server_name terraform.mydocker.ga www.terraform.mydocker.ga;

        location / {
                try_files $uri $uri/ =404;
        }
}




Next, let’s enable the file by creating a link from it to the sites-enabled directory, which Nginx reads from during startup:

     sudo ln -s /etc/nginx/sites-available/terraform.mydocker.ga /etc/nginx/sites-enabled/


Two server blocks are now enabled and configured to respond to requests based on their listen and server_name directives (you can read more about how Nginx processes these directives here):

example.com: Will respond to requests for example.com and www.example.com.
default: Will respond to any requests on port 80 that do not match the other two blocks.
To avoid a possible hash bucket memory problem that can arise from adding additional server names, it is necessary to adjust a single value in the /etc/nginx/nginx.conf file. Open the file:



sudo nano /etc/nginx/nginx.conf

...
http {
    ...
    server_names_hash_bucket_size 64;
    ...
}

NOW IT WILL WORK : THE TEST
---------------------------
sudo systemctl restart nginx

```

nginx How To Secure Nginx with Let's Encrypt on Ubuntu 18.04

```
1 installing Cerbot

The first step to using Let’s Encrypt to obtain an SSL certificate is to install the Certbot software on your server.

Certbot is in very active development, so the Certbot packages provided by Ubuntu tend to be outdated. However, the 
Certbot developers maintain a Ubuntu software repository with up-to-date versions, so we’ll use that repository instead.

--First, add the repository:

sudo add-apt-repository ppa:certbot/certbot

--You’ll need to press ENTER to accept.

--Install Certbot’s Nginx package with apt:

sudo apt install python-certbot-nginx

2. Confirming Nginx’s Configuration (wee created earlier in sblock section)


sudo nano /etc/nginx/sites-available/registry.mydocker.ga

results:
    
     server_name registry.mydocker.ga www.registry.mydocker.ga;
     
3. Allowing HTTPS Through the Firewall (ignore doesnt work and not needed)


4. Obtaining an SSL Certificate  for (registry.mydocker.ga)

sudo certbot --nginx -d registry.mydocker.ga -d www.registry.mydocker.ga

If this is your first time running certbot, you will be prompted to enter an email 
address and agree to the terms of service. After doing so, certbot will communicate
with the Let’s Encrypt server, then run a challenge to verify that you control the 
domain you’re requesting a certificate for.

Output
Please choose whether or not to redirect HTTP traffic to HTTPS, removing HTTP access.
-------------------------------------------------------------------------------
1: No redirect - Make no further changes to the webserver configuration.
2: Redirect - Make all requests redirect to secure HTTPS access. Choose this for
new sites, or if you're confident your site works on HTTPS. You can undo this
change by editing your web server's configuration.
-------------------------------------------------------------------------------
Select the appropriate number [1-2] then [enter] (press 'c' to cancel):

select 1

5. Verifying Certbot Auto-Renewal

sudo certbot renew --dry-run

```




Main Install
--------


```

Step 1  : Installing and Configuring the Docker Registry
--------------------------------------------------------


Install docker-compose

sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

Output
docker-compose version 1.21.2, build a133471

Create Docker registry

mkdir ~/docker-registry && cd $_
mkdir data

see docker-compose.yml in this folder




Step 2 — Setting Up Nginx Port Forwarding
-----------------------------------------


See nginx How To Secure Nginx with Let's Encrypt on Ubuntu 18.04

You already have HTTPS set up on your Docker Registry server with Nginx, which
means you can now set up port forwarding from Nginx to port 5000. Once you complete 
this step, you can access your registry directly at example.com.

As part of the How to Secure Nginx With Let’s Encrypt prerequisite, you have already 
set up the /etc/nginx/sites-available/example.com file containing your server configuration.


sudo nano /etc/nginx/sites-available/registry.mydocker.ga
enter:

location / {
    # Do not allow connections from docker 1.5 and earlier
    # docker pre-1.6.0 did not properly set the user agent on ping, catch "Go *" user agents
    if ($http_user_agent ~ "^(docker\/1\.(3|4|5(?!\.[0-9]-dev))|Go ).*$" ) {
      return 404;
    }

    proxy_pass                          http://localhost:5000;
    proxy_set_header  Host              $http_host;   # required for docker client's sake
    proxy_set_header  X-Real-IP         $remote_addr; # pass on real client's IP
    proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Proto $scheme;
    proxy_read_timeout                  900;
}

save

sudo service nginx restart



Step 3 — Setting Up Authentication
----------------------------------


You can install the htpasswd package by running the following:

sudo apt install apache2-utils

mkdir ~/docker-registry/auth && cd $_

Next, you will create the first user as follows, replacing username with the 
username you want to use. The -B flag specifies bcrypt encryption, which is more s
ecure than the default encryption. Enter the password when prompted:

htpasswd -Bc registry.password <username>

i.e.

New password:
Re-type new password:
Adding password for user admin




see the docker-compose.yml file  (rem FILESYSTEM REPLACED BY S3)

version: '3'

services:
  registry:
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_AUTH: htpasswd
      REGISTRY_AUTH_HTPASSWD_REALM: Registry
      REGISTRY_AUTH_HTPASSWD_PATH: /auth/registry.password
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./auth:/auth 
      - ./data:/data



Step 4 — Starting Docker Registry as a Service
----------------------------------------------


nano docker-compose.yml
Add the following line of content under registry::

docker-compose.yml
...
  registry:
    restart: always
...


Step 5 — Increasing File Upload Size for Nginx
----------------------------------------------


sudo nano /etc/nginx/nginx.conf
Find the http section, and add the following line:

/etc/nginx/nginx.conf
...
http {
        client_max_body_size 2000M;
        ...
}
...

You can now upload large images to your Docker Registry without Nginx errors.


Step 6 — Publishing to Your Private Docker Registry
---------------------------------------------------


```


Use
----

```

login:
docker login https://registry.mydocker.ga

username : admin
password : a****


pushing
-------
tag:
docker tag <image> registry.mydocker.ga/ubuntu

push:
sudo docker push  registry.mydocker.ga/ubuntu
sudo docker push registry.mydocker.ga/jenkins-server


S3
--
Check s3 bucket

https://s3.console.aws.amazon.com/s3/buckets/pipline-registry-bucket/image-registry/docker/registry/v2/repositories/?region=eu-west-2&tab=overview#

pipeline-registry-bucket

```
