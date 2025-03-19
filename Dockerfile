# Sử dụng Node 18 (hạ từ Node 23)
FROM node:18-alpine AS builder

# Cài đặt dependencies cần thiết để build node-sass
RUN apk add --no-cache python3 make g++ 

WORKDIR /app

# Sao chép package.json để cài dependencies trước
COPY package*.json ./

# Cài đặt các package (bật optional cho node-sass nếu cần)
RUN npm install --unsafe-perm

# Copy toàn bộ mã nguồn vào container
COPY . .

# Build ứng dụng
RUN npm run build

# Sử dụng Nginx để serve frontend
FROM nginx:alpine

# Sao chép build từ bước builder
COPY --from=builder /app/build /usr/share/nginx/html

# Cấu hình Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Mở cổng 80
EXPOSE 80

