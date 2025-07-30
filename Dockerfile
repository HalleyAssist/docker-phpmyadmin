ARG BASE_IMAGE=phpmyadmin:latest
FROM ${BASE_IMAGE} as base

# Install packages needed for TLS/SSL support
RUN apt-get update && apt-get install -y \
    openssl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSL certificates
RUN mkdir -p /etc/ssl/certs/phpmyadmin

# Copy custom Apache configuration for SSL
COPY apache-ssl.conf /etc/apache2/sites-available/default-ssl.conf

# Enable SSL module and site
RUN a2enmod ssl && \
    a2enmod headers && \
    a2ensite default-ssl

# Create self-signed certificate if none provided
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/certs/phpmyadmin/tls.key \
    -out /etc/ssl/certs/phpmyadmin/tls.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"


FROM ${BASE_IMAGE}

COPY --from=base / /

# Expose both HTTP and HTTPS ports
EXPOSE 80 443

# Start Apache in foreground
CMD ["apache2-foreground"]