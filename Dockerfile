FROM n8nio/n8n:latest

ENV GENERIC_TIMEZONE=Europe/Madrid
ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

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

RUN n8n import:workflow --separate --input=/home/node/.n8n/nodes/workflows/
RUN n8n update:workflow --all --active=true
RUN n8n import:credentials --separate --input=/home/node/.n8n/nodes/credentials

EXPOSE 5678


COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
