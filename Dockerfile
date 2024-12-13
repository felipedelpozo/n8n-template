FROM n8nio/n8n:latest

ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

USER root

# RUN apk add --no-cache shadow && \
#     groupadd -r n8n && \
#     useradd -r -g n8n -d /home/node -s /sbin/nologin n8n && \
#     mkdir -p /home/node/.n8n/nodes /home/node/.cache && \
#     touch /home/node/.n8n/config && \
#     chown -R n8n:n8n /home/node/.n8n /home/node/.cache && \
#     chmod 700 /home/node/.n8n && \
#     chmod 600 /home/node/.n8n/config && \
#     apk del shadow

RUN mkdir -p /home/node/.n8n/nodes && \
    touch /home/node/.n8n/config && \
    chown -R node:node /home/node/.n8n && \
    chmod 700 /home/node/.n8n && \
    chmod 600 /home/node/.n8n/config

USER node

COPY ./workflows ./workflows

# COPY ./credentials ./credentials

RUN cd /home/node/.n8n/nodes && \
    npm install --production --force n8n-nodes-browserless n8n-nodes-evolution-api \ 
    n8n-nodes-globals @splainez/n8n-nodes-phonenumber-parser \
    n8n-nodes-edit-image-plus

# RUN n8n import:workflow --separate --input=./workflows/
# RUN n8n update:workflow --all --active=true
# RUN n8n import:credentials --separate --input=./credentials

CMD ["n8n", "start"]
