#!/bin/sh

exec n8n import:workflow --separate --input=/home/node/.n8n/nodes/workflows/
exec n8n update:workflow --all --active=true
exec n8n import:credentials --separate --input=/home/node/.n8n/nodes/credentials

if [ "$#" -gt 0 ]; then
  # Got started with arguments
  exec n8n "$@"
else
  # Got started without arguments
  exec n8n
fi