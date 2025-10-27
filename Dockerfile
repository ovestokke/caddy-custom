ARG CADDY_VERSION=2.10.2
ARG ALPINE_VERSION=3.22.1

FROM caddy:${CADDY_VERSION}-builder-alpine AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare \
#    --with github.com/abiosoft/caddy-hmac \
#    --with github.com/caddy-dns/dnspod \
#    --with github.com/caddy-dns/gandi \
#    --with github.com/caddy-dns/route53 \
#    --with github.com/caddy-dns/alidns \
#    --with github.com/caddy-dns/azure \
#    --with github.com/caddy-dns/digitalocean \
#    --with github.com/caddy-dns/duckdns \
#    --with github.com/caddy-dns/hetzner \
#    --with github.com/caddy-dns/openstack-designate \
#    --with github.com/caddy-dns/vultr \
#    --with github.com/mholt/caddy-dynamicdns \
#    --with github.com/lolPants/caddy-requestid \
#    --with github.com/mholt/caddy-webdav \
#    --with github.com/abiosoft/caddy-json-parse \    
#    --with github.com/porech/caddy-maxmind-geolocation \
    --with github.com/gsmlg-dev/caddy-admin-ui@main \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/mholt/caddy-l4 \
    --with github.com/caddyserver/transform-encoder \
    --with github.com/hslatman/caddy-crowdsec-bouncer/appsec \
    --with github.com/hslatman/caddy-crowdsec-bouncer/http@main \
    --with github.com/hslatman/caddy-crowdsec-bouncer/layer4@main

# Certs stage
FROM alpine:${ALPINE_VERSION} AS certs
RUN apk add --no-cache ca-certificates tzdata

FROM caddy:${CADDY_VERSION}-alpine
EXPOSE 80 443 2019 443/udp

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=certs /usr/share/zoneinfo /usr/share/zoneinfo
