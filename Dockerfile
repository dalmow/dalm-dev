FROM node:22-alpine AS build

WORKDIR /src

COPY package.json ./
RUN npm install
RUN npm ci

COPY . .
RUN npm run build

FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /src/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]