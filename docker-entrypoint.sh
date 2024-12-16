#!/bin/sh

exec sh -c "/sbin/n8n_import.sh"

if [ "$#" -gt 0 ]; then
  # Got started with arguments
  exec n8n "$@"
else
  # Got started without arguments
  exec n8n
fi