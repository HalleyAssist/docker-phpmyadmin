# docker-phpmyadmin
An extension of the official phpmyadmin containers to add TLS/SSL support in a similar way to the old bitnami phpmyadmin containers.

## Features
- Based on the official phpMyAdmin image (phpmyadmin:latest)
- Automatic SSL/TLS encryption with self-signed certificates
- HTTPS redirection from HTTP
- Modern SSL configuration with security headers
- Exposes both HTTP (port 80) and HTTPS (port 443)

## Usage

### Using Docker Hub
```bash
docker run -d \
  --name phpmyadmin-ssl \
  -p 80:80 \
  -p 443:443 \
  -e PMA_HOST=mysql_server \
  halleyassisau/docker-phpmyadmin:latest
```

### Building locally
```bash
git clone https://github.com/HalleyAssist/docker-phpmyadmin.git
cd docker-phpmyadmin
docker build -t phpmyadmin-ssl .
docker run -d --name phpmyadmin-ssl -p 80:80 -p 443:443 phpmyadmin-ssl
```

## Custom SSL Certificates
To use your own SSL certificates, mount them into the container:
```bash
docker run -d \
  --name phpmyadmin-ssl \
  -p 80:80 \
  -p 443:443 \
  -v /path/to/your/cert.crt:/etc/ssl/certs/phpmyadmin/server.crt \
  -v /path/to/your/key.key:/etc/ssl/certs/phpmyadmin/server.key \
  halleyassisau/docker-phpmyadmin:latest
```

## Environment Variables
All environment variables from the official phpMyAdmin image are supported. See the [official documentation](https://hub.docker.com/_/phpmyadmin) for details.

## Auto-Update Feature
This repository includes an automated workflow that:
- Checks daily for new releases of the base phpMyAdmin image
- Automatically builds and tests the image with the "next" tag when updates are detected
- Promotes to "latest" tag and merges to main branch after successful testing
- Provides summary reports of update activities

The auto-update workflow runs daily at 2:00 AM UTC and can also be triggered manually from the GitHub Actions interface.
