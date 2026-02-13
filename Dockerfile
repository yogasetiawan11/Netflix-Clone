FROM node:18-alpine AS builder

WORKDIR /app

RUN groupadd -r worker && useradd -r -g worker worker \
    && chown -R worker:worker /app
    
COPY package*.json ./app
RUN npm install
COPY . .

EXPOSE 3000 
USER worker

FROM node:18-slim
WORKDIR /app
COPY --from=builder /app/src/app.js .
COPY --from=builder /app/node_module ./app
CMD ["index.js"]