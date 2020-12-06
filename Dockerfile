# 1rd Stage
FROM node:alpine as build-deps

COPY package*.json /build/

WORKDIR /build

RUN npm install

# debugger
FROM node:alpine as debug

COPY --from=build-deps /build /app

WORKDIR /app

COPY . .

RUN npm install -g ts-node-dev

ENTRYPOINT [ "ts-node-dev", "--inspect=0.0.0.0:9229", "--exit-child", "--respawn", "--transpile-only", "--ignore-watch", "node_modules", "--no-notify", "src/app.ts"]

# 2rd Stage
FROM node:alpine as compile-env
RUN mkdir /compile
COPY --from=build-deps /build /compile
WORKDIR /compile
COPY . .
RUN npm run build 

# 3rd Stage
FROM node:alpine as runtime-deps
COPY --from=build-deps /build /build
WORKDIR /build
RUN npm prune --production

# 4rd Stage
FROM node:alpine as runtime-env
WORKDIR /app
COPY --from=compile-env --chown=node:node /compile/dist /app
COPY --from=runtime-deps --chown=node:node /build /app

USER node

EXPOSE 8000

CMD ["node", "app.js"]