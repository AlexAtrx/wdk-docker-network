FROM node:20-bookworm

# Install build dependencies for native modules (gyp, etc.)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# We don't copy code here because we mount it via Compose for local dev.
# We will run npm rebuild at runtime if needed.
