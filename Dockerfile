FROM n8nio/n8n:latest

ARG N8N_ENCRYPTION_KEY
ARG N8N_BASIC_AUTH_USER
ARG N8N_BASIC_AUTH_PASSWORD

ENV GENERIC_TIMEZONE=Europe/Madrid
ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=$N8N_BASIC_AUTH_USER
ENV N8N_BASIC_AUTH_PASSWORD=$N8N_BASIC_AUTH_PASSWORD

USER root

RUN mkdir -p /home/node/.n8n/nodes

COPY ./workflows /home/node/.n8n/nodes/workflows
COPY ./credentials /home/node/.n8n/nodes/credentials

RUN chown -R node:node /home/node/.n8n && \
    chmod 700 /home/node/.n8n

USER node

RUN cd /home/node/.n8n/nodes && \
    npm install --omit=dev n8n-nodes-browserless n8n-nodes-evolution-api \ 
    n8n-nodes-globals @splainez/n8n-nodes-phonenumber-parser \
    n8n-nodes-edit-image-plus

RUN N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY n8n import:workflow --separate --input=/home/node/.n8n/nodes/workflows/
RUN N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY n8n update:workflow --all --active=true
RUN N8N_ENCRYPTION_KEY=$N8N_ENCRYPTION_KEY n8n import:credentials --separate --input=/home/node/.n8n/nodes/credentials

CMD ["n8n", "start"]
