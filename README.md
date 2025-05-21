# DEMO QUICK 1

## Archi

 * Appli : Spring Boot MVC => Base PostGreSQL
 * CICD :  GitHub => GitHub Actions => OC (Oracle Cloud) VM (Ubuntu + Docker)
 * Accès : DNS duckdns.org => OC Virtual Cloud Network (réseau + firewall) => VM OC (Appli (terminaison TLS)) => Supabase (PostGreSQL Managé)

## CertBot

### Init certificat

```
docker run --rm -p 80:80 --name certbot \
  -v /etc/letsencrypt:/etc/letsencrypt \
  certbot/certbot certonly --standalone \
  --preferred-challenges http \
  -d aymhce.duckdns.org --agree-tos --email aymhce@gmail.com --non-interactive
sudo chmod -R 775 /etc/letsencrypt/*
sudo chown -R :ubuntu /etc/letsencrypt/*
```

### Renew certificat

```
docker run --rm --name certbot \
  -v /etc/letsencrypt:/etc/letsencrypt \
  certbot/certbot renew
```



openssl pkcs12 -export -in /etc/letsencrypt/live/aymhce.duckdns.org/fullchain.pem \
  -inkey /etc/letsencrypt/live/aymhce.duckdns.org/privkey.pem \
  -out keystore.p12 -name springboot \
  -CAfile /etc/letsencrypt/live/aymhce.duckdns.org/chain.pem -caname root \
  -password pass:changeit
