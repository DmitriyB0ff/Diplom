# build
FROM node:16.20.0-alpine3.18 AS builder 
ARG VERSION=${VERSION}
#ARG NODE_ENV=production 
#ARG VUE_APP_API_URL=http://localhost:8081
WORKDIR '/app'
COPY . .
RUN npm install
#RUN npm install -g @vue/cli
RUN npm run build -- --output-path=dist

#release 
FROM nginx:latest 
RUN rm -rf /usr/share/nginx/html/*
#RUN mkdir /usr/share/nginx/html/momo-store
COPY --from=builder /app/dist /usr/share/nginx/html
COPY --from=builder /app/dist /usr/share/nginx/html/momo-store
RUN rm /etc/nginx/conf.d/default.conf
COPY ./nginx/default.conf /etc/nginx/conf.d/
USER root
RUN chmod -R 775 /usr/share/nginx/html
EXPOSE 80
#ENTRYPOINT ["nginx"]
