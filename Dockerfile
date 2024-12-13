FROM n8nio/n8n:latest

ENV GENERIC_TIMEZONE=Europe/Madrid
ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=false

USER node
COPY ./workflows /home/node/.n8n/nodes/workflows

#COPY ./credentials ./credentials

WORKDIR /home/node/.n8n/nodes

RUN cd /home/node/.n8n/nodes && \
    npm install --production --force n8n-nodes-browserless n8n-nodes-evolution-api \ 
    n8n-nodes-globals @splainez/n8n-nodes-phonenumber-parser \
    n8n-nodes-edit-image-plus

RUN n8n import:workflow --separate --input=/home/node/.n8n/nodes/workflows/
# RUN n8n update:workflow --all --active=true
# RUN n8n import:credentials --separate --input=./credentials

CMD ["n8n", "start"]
