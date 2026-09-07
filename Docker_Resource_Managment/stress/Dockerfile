FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends stress-ng \
    && rm -rf /var/lib/apt/lists/*

CMD ["stress-ng", "--cpu", "1"]
