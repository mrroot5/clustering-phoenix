#!/usr/bin/env bash

mix setup
echo "Comando recibido: $@"
exec "$@"
