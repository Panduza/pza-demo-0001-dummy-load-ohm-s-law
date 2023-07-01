#!/bin/bash

# Start web server
docker run --rm -d --name doc-server \
    -v $PWD:/usr/share/nginx/html:ro \
    -v $PWD/nginx.conf:/etc/nginx/conf.d/default.conf:ro \
    -p 8080:80 nginx

echo "Report up on port 8080"
