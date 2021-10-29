server {
    listen         80;
    server_name waterproofyard.com www.waterproofyard.com;
    return 301 https://waterproofyard.com$request_uri;
}
server {
# Document Root
root /var/www/waterproofyard.com;
index index.php index.html index.htm;
server_name waterproofyard.com www.waterproofyard.com;
client_max_body_size 0;

    listen [::]:443 ssl http2 ;
    listen 443 ssl http2;
        ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
        ssl_certificate /etc/letsencrypt/live/waterproofyard.com/fullchain.pem;
        ssl_certificate_key /etc/letsencrypt/live/waterproofyard.com/privkey.pem;
        ssl_prefer_server_ciphers on;
        ssl_session_cache   shared:SSL:20m;
        ssl_session_timeout 20m;
        ssl_ciphers 'TLS13+AESGCM+AES128:EECDH+AES128';


error_page 404 /404.html;
error_page 500 502 503 504 /50x.html;

location / {
    try_files $uri $uri/ /index.php$is_args$args;
}

location ~* \.php$ {
if ($uri !~ "^/uploads/") {
fastcgi_pass unix:/run/php/php7.4-fpm.sock;
}
include fastcgi_params;
fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
fastcgi_param SCRIPT_NAME $fastcgi_script_name;
}
location = /favicon.ico {
log_not_found off;
access_log off;
}

location = /robots.txt {
log_not_found off;
access_log off;
allow all;
}

location ~* .(css|gif|svg|ico|jpeg|jpg|js|png)$ {
expires 1y;
log_not_found off;
}

# Enable Gzip compression.
gzip on;

# Disable Gzip on IE6.
gzip_disable "msie6";

# Allow proxies to cache both compressed and regular version of file.
# Avoids clients that don't support Gzip outputting gibberish.
gzip_vary on;

# Compress data, even when the client connects through a proxy.
gzip_proxied any;

# The level of compression to apply to files. A higher compression level increases
# CPU usage. Level 5 is a happy medium resulting in roughly 75% compression.
gzip_comp_level 5;

# Compress the following MIME types.
gzip_types
 application/atom+xml
 application/javascript
 application/json
 application/ld+json
 application/manifest+json
 application/rss+xml
 application/vnd.geo+json
 application/vnd.ms-fontobject
 application/x-font-ttf
 application/x-web-app-manifest+json
 application/xhtml+xml
 application/xml
 font/opentype
 image/bmp
 image/svg+xml
 image/x-icon
 text/cache-manifest
 text/css
 text/plain
 text/vcard
 text/vnd.rim.location.xloc
 text/vtt
 text/x-component
 text/x-cross-domain-policy;
}
