FROM node:18-alpine AS builder

WORKDIR /app

RUN groupadd -r worker && useradd -r -g worker worker
    
COPY package*.json ./app
RUN npm install
COPY . .

EXPOSE 4000 
USER worker

FROM gcr.io/distroless/nodejs24-debian12
WORKDIR /app
COPY --from=builder /app/src/app.js .
COPY --from=builder /app/node_module ./app
CMD ["index.js"]