FROM node:14-alpine AS build

WORKDIR /app

RUN echo "https://dl-cdn.alpinelinux.org/alpine/v3.15/community"  >> /etc/apk/repositories
RUN apk add --no-cache git make gcc g++ python2 curl && rm -rf /var/cache/apk/*
RUN [ -e /usr/bin/python ] || ln -s /usr/bin/python2 /usr/bin/python

COPY ./package*.json ./
RUN npm install -g @angular/cli@15.2.0
RUN npm install

COPY . .
# RUN npm run build:prod
RUN npm run build -- --output-path=dist --output-hashing=all --configuration production --aot

FROM nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY ./nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]
