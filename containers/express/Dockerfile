FROM node
WORKDIR /app
COPY ./containers/express/package.json /app
RUN npm install
COPY ./containers/express /app
COPY ./certs/platform.local.crt /app/platform.local.crt
COPY ./certs/platform.local.key /app/platform.local.key
EXPOSE 443
CMD ["node","app.js"]