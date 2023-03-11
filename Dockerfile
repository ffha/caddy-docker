FROM golang:alpine AS build
RUN apk add --no-cache build-base && go install -ldflags "-s -w" github.com/caddyserver/xcaddy/cmd/xcaddy@latest
WORKDIR /app
ENV XCADDY_GO_BUILD_FLAGS="-ldflags '-s -w'
RUN xcaddy build \
           --with github.com/caddyserver/transform-encoder \
           --with github.com/caddyserver/ntlm-transport \ 
           --with github.com/caddy-dns/cloudflare \
           --with github.com/caddyserver/replace-response \
           --with github.com/caddy-dns/dnspod \
           --with github.com/caddyserver/nginx-adapter \
           --with github.com/caddy-dns/gandi \
           --with github.com/caddy-dns/route53 \
           --with github.com/caddyserver/cache-handler \
FROM alpine
COPY --from=build /app /app
WORKDIR /app
CMD ["./caddy", "run"]
