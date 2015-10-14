FROM node:0.12-slim
ADD package.json /
ADD gulpfile.babel.js /
RUN npm install
ADD ./src /src
VOLUME /assets
CMD ["npm", "run-script", "build"]
