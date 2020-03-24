FROM node:12 AS blog-nx-base
WORKDIR /app
COPY . .
RUN npm ci -S
RUN npm run build -S
RUN npm prune --production -S

FROM nginx:alpine AS blog-nx-ui
COPY nginx.conf /etc/nginx/nginx.conf
WORKDIR /usr/share/nginx/html
COPY --from=blog-nx-base /app/dist/apps/blog-nx-docker .

FROM node:12 AS blog-nx-api
EXPOSE 3333
WORKDIR /app
COPY --from=blog-nx-base /app/node_modules /app/node_modules
COPY --from=blog-nx-base /app/dist/apps/api .
CMD ["node", "main.js"]

