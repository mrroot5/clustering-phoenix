FROM amd64/elixir:1.18.4-otp-27-slim

# Create required dirs
RUN mkdir /app

# Install required packages
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -qq && \
    apt install -y --no-install-recommends inotify-tools \
    ca-certificates \
    git && \
    apt clean && \
    apt autoclean && \
    rm -rf /var/lib/apt/lists/*

# Install hex, rebar and phoenix
RUN mix local.hex --force && \
    mix local.rebar --force

# Set /app as workdir
WORKDIR /app
