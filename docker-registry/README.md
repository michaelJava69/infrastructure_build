README

links

https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-18-04

https://icicimov.github.io/blog/docker/Docker-Private-Registry-with-S3-backend-on-AWS/
https://github.com/cirocosta/sample-docker-registry-aws




MAC Users

Rem

docker-machine start
eval $(docker-machine env default)


Install
------

 
```
install nginx

After the regitry installed and linked to S3 bucket  (terraform)


sudo apt update
sudo apt install nginx


systemctl status nginx.    # just a check
 

Check access to nginx server 
—————————————---------------- 

Add rules to instance to open up port 80 and port 443


Server blocks manually
———————---------------

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


now goto browser and type registry.dcoker.ga


Creating Sever block with script
-------------------------------

goto utilities copy script (nginx_sblock.sh) onto docker registry server\

./nginx_sblock.sh <domain A-record> 

i.e  ./nginx_sblock.sh registry.docker.ga

now goto browser and type registry.dcoker.ga

ans : 
regsitry.mydocker.ga
Hello World
© 2020



REM BEFOR TEST in browser
---------------------------
sudo systemctl restart nginx

```


Use
----

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
