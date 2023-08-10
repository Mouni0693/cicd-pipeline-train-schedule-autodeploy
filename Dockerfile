FROM node:carbon
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8080
CMD [ "npm", "start" ]

# Access GIT_COMMIT environment variable
COMMIT_HASH="${GIT_COMMIT}"

# Tag the Docker image with the Git commit hash
IMAGE_NAME="balacse530/NPMIMAGE"
docker build -t "${IMAGE_NAME}:${COMMIT_HASH}" .
