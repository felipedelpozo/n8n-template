FROM n8nio/n8n

ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

USER node

COPY ./workflows ./workflows
# COPY ./credentials ./credentials

RUN mkdir -p ~/.n8n/nodes

RUN cd ~/.n8n/nodes && \
    npm install --production --force n8n-nodes-browserless n8n-nodes-evolution-api \ 
    n8n-nodes-globals @splainez/n8n-nodes-phonenumber-parser \
    n8n-nodes-edit-image-plus

RUN chmod -R 700 ~/.n8n && chmod 600 ~/.n8n/config

RUN n8n import:workflow --separate --input=./workflows/
RUN n8n update:workflow --all --active=true
# RUN n8n import:credentials --separate --input=./credentials

CMD ["n8n", "start"]
