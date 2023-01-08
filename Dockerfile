# Dockerfile
# 현재 From 부터 다음 From 까지 builder stage임을 명시
FROM node:alpine as builder
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY ./ ./
# 빌드 파일 생성
CMD ["npm", "run", "build"]

# nginx 베이스 이미지
FROM nginx
# 다른 stage에 있는 파일을 복사할 때, stage이름 명시
# /usr/src/app/build 의 파일을 /usr/share/nginx/html로 복사
# 빌드 파일을 /usr/share/nginx/html 로 놓는 이유는 nginx가 알아서 client에서 요청이 올 때 알맞은 정적 파일 제공이 가능, 설정을 통해 바꿀 수 있다.
COPY --from=builder /usr/src/app/build /usr/share/nginx/html