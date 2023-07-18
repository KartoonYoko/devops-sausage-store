FROM node:16 AS builder
WORKDIR /usr/src/app
COPY . .
RUN npm install
RUN npm run build
# ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://backend:8080"]

FROM nginxproxy/nginx-proxy:latest
COPY --from=builder /usr/src/app/nginx.conf /app/nginx.tmpl
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html