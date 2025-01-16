FROM --platform=linux/amd64 n8nio/n8n:1.74.1

ENV NODE_ENV=production
ENV GENERIC_TIMEZONE=Europe/Madrid
ENV TZ=Europe/Madrid
ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

USER root

RUN mkdir -p /home/node/.n8n/nodes && \
    chown -R node:node /home/node/.n8n && \
    chmod -R 700 /home/node/.n8n

RUN cd /home/node/.n8n/nodes && \
    npm install --omit=dev n8n-nodes-browserless n8n-nodes-evolution-api \ 
    n8n-nodes-globals @splainez/n8n-nodes-phonenumber-parser \
    n8n-nodes-edit-image-plus n8n-nodes-text-manipulation \
    n8n-nodes-document-generator

USER node
EXPOSE 5678