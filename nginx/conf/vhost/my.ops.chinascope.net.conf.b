server {
	listen	80;
	server_name my.ops.chinascope.net;

	index index.html;
	root  D:/document.root/main-git/web/ops/static;

    location /apis/ {
        proxy_pass http://192.168.0.143:5000;
        proxy_set_header X-Forwarded-For $remote_addr;
    }

	access_log  D:/document.root/logs/my.ops.chinascope.net_access.log;
	error_log   D:/document.root/logs/my.ops.chinascope.net_error.log;

}