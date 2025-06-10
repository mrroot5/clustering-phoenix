FROM amd64/elixir:1.18.4-otp-27

# Create required dirs
RUN mkdir /app

# Install hex, rebar and phoenix
RUN mix local.hex --force

# Install required packages
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update -qq && \
    apt install -y --no-install-recommends inotify-tools && \
    apt clean && \
    apt autoclean && \
    rm -rf /var/lib/apt/lists/*

# Set /app as workdir
WORKDIR /app
