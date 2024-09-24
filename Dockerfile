FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:20 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
# Copy source code
COPY . .


FROM --platform=linux/amd64 public.ecr.aws/docker/library/node:20-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
  curl \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* && apt-get clean
COPY --from=build /app .

COPY package*.json ./
RUN npm install --only=production

EXPOSE 3000
CMD ["node", "index.js"]
