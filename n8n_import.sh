#!/bin/sh

n8n import:workflow --separate --input=/home/node/.n8n/nodes/workflows/
n8n update:workflow --all --active=true
n8n import:credentials --separate --input=/home/node/.n8n/nodes/credentials