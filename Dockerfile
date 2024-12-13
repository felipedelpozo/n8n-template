FROM n8nio/n8n:latest

ARG ENCRYPTION_KEY

ENV GENERIC_TIMEZONE=Europe/Madrid
ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
ENV N8N_ENCRYPTION_KEY=$ENCRYPTION_KEY

RUN printenv

USER root

RUN mkdir -p /home/node/.n8n/nodes

COPY ./configs/config /home/node/.n8n/config
COPY ./workflows /home/node/.n8n/nodes/workflows
COPY ./credentials /home/node/.n8n/nodes/credentials

RUN chown -R node:node /home/node/.n8n && \
    chmod 700 /home/node/.n8nchown -R node:node /home/node/.n8n/config && \
    chmod 600 /home/node/.n8n/config

USER node

RUN cd /home/node/.n8n/nodes && \
    npm install --omit=dev n8n-nodes-browserless n8n-nodes-evolution-api \ 
    n8n-nodes-globals @splainez/n8n-nodes-phonenumber-parser \
    n8n-nodes-edit-image-plus

RUN n8n import:workflow --separate --input=/home/node/.n8n/nodes/workflows/
RUN n8n update:workflow --all --active=true
RUN n8n import:credentials --separate --input=/home/node/.n8n/nodes/credentials

CMD ["n8n", "start"]
