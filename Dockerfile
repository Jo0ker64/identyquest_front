FROM ghcr.io/cirruslabs/flutter:3.22.1

WORKDIR /app

COPY . .

RUN flutter pub get

EXPOSE 5000

CMD ["flutter", "run", "-d", "chrome", "--web-port=5000"]
