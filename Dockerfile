
FROM node:18-alpine AS builder

# Cài đặt các dependencies cần thiết để build ứng dụng
RUN apk add --no-cache python3 make g++

WORKDIR /app

# Sao chép package.json và package-lock.json để tối ưu cache layer
COPY package*.json ./

# Cập nhật npm lên bản mới nhất để tránh lỗi "old lockfile"
RUN npm install -g npm@latest

# Chạy npm ci thay vì npm install để đảm bảo lockfile được sử dụng đúng
RUN npm ci --unsafe-perm --legacy-peer-deps

# Copy toàn bộ mã nguồn vào container
COPY . .

# Build ứng dụng
RUN npm run build

# Sử dụng Nginx để serve frontend
FROM nginx:alpine

# Sao chép build từ bước builder
COPY --from=builder /app/build /usr/share/nginx/html

# Sao chép file cấu hình Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Mở cổng 80
EXPOSE 80

# Chạy Nginx
CMD ["nginx", "-g", "daemon off;"]

