# The bahut project

**BAHUT** (a French word of unknown origin), a portable coffer or chest, with a rounded lid covered in leather, garnished with nails, used for the transport of clothes or other personal luggage,—it was, in short, the original portmanteau.[[1]](https://en.wikisource.org/wiki/1911_Encyclop%C3%A6dia_Britannica/Bahut)

This is a personal project for a self-hosted file server using Fedora Server 40, Docker, Nextcloud, Nginx Proxy Manager, and Tailscale.

# Installation
WIP

## Generating the SSL certificate
 `openssl req  -nodes -new -x509  -keyout server.key -out server.cert`

## Setting up Nginx

Add a new proxy host pointing the Tailscale domain to `http://{LOCAL_IP}:8080` and selecting the previously-generated SSL certificate.
