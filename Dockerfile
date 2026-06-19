FROM rust:1.96-slim-trixie AS builder

RUN rustup target add wasm32-unknown-unknown
RUN cargo install trunk

WORKDIR /app

COPY Cargo.toml ./
COPY index.html .
COPY Trunk.toml .
COPY src ./src

RUN trunk build --release

FROM nginx:1.30-alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]