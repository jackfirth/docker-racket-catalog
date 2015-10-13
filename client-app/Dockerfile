FROM node:0.12-slim
ADD package.json /
ADD gulpfile.babel.js /
RUN npm install
ADD ./src /src
RUN npm run-script build
VOLUME /assets
