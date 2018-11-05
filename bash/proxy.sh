
#::::::::::::::::::::PROXY::::::::::::::::::::

#Setup named/bind as a service:
yum install -y bind bind-utils
systemctl start named
systemctl enable named
named-checkconf /etc/named.conf #test configuration
yum install -y checkzone
named-checkzone example.com example.com #test zone file
yum install -y httpd mod_proxy_html

vi /etc/resolv.conf:
  nameserver 127.0.0.1

vi /etc/named.conf:
  options {
    directory "/var/named";
    forward only;
    forwarders { 8.8.8.8; 8.8.4.4; }; #replace with auth DNS IPs
  };

  zone "." {
    type hint;
    file "named.ca";
  };

  zone "example.com" {
    type master;
    file "example.com";
  };

vi /etc/httpd/conf/httpd.conf
  ServerTokens OS
  ServerSignature On
  TraceEnable On

  ServerName "host.com"
  ServerRoot "/etc/httpd"
  PidFile run/httpd.pid
  Timeout 120
  KeepAlive Off
  MaxKeepAliveRequests 100
  KeepAliveTimeout 15
  LimitRequestFieldSize 8190

  User nobody
  Group nobody

  AccessFileName .htaccess
  <FilesMatch "^\.ht">
      Require all denied
  </FilesMatch>

  <Directory />
    Options FollowSymLinks
    AllowOverride None
  </Directory>

  HostnameLookups Off
  ErrorLog "/var/log/httpd/error_log"
  EnableSendfile On

  Listen 8085
  UseCanonicalName On
  ServerSignature On

  LoadModule proxy modules/mod_proxy.so
  Include "/etc/httpd/conf.modules.d/*.load"
  Include "/etc/httpd/conf.modules.d/*.conf"
  Include "/etc/httpd/conf/ports.conf"

  #Concise log format, but verbose lines:
  LogLevel trace8
  ErrorLogFormat "%t[%m]: %M"

  #This is just a proxy, so don't include other configs:
  #IncludeOptional "/etc/httpd/conf.d/*.conf"

  #Set up a local proxy using /etc/named DNS:
  ProxyRequests On
  ProxyVia On
  RewriteEngine on
  RewriteOptions AllowAnyURI

  #Allow port override seamlessly (not redirected in browser) in the proxy:
  AllowConnect 443 8443

  RewriteCond %{HTTP_HOST} ^example.com$
  RewriteCond %{SERVER_PORT} ^80$
  RewriteRule example\.com/(.*)$ http://example.com:8080/$1 [L,P]

  RewriteCond %{REQUEST_METHOD} CONNECT
  RewriteRule example\.com:443$ example.com:8443 [L,P]