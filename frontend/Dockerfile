FROM nginx:alpine

RUN mkdir -p /app/staticfiles /app/site
RUN rm /etc/nginx/conf.d/default.conf /etc/nginx/nginx.conf

COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/sistemascead.conf /etc/nginx/conf.d/sistemascead.conf
COPY sistemascead-frontend/ /var/www/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
