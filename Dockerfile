FROM n8nio/n8n

ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG DB_POSTGRESDB_DATABASE
ARG PGUSER

ARG USERNAME
ARG PASSWORD

ENV DB_TYPE=postgresdb
ENV DB_POSTGRESDB_DATABASE=$PGDATABASE
ENV DB_POSTGRESDB_HOST=$PGHOST
ENV DB_POSTGRESDB_PORT=$PGPORT
ENV DB_POSTGRESDB_USER=$PGUSER
ENV DB_POSTGRESDB_PASSWORD=$PGPASSWORD

ENV N8N_BASIC_AUTH_ACTIVE=true
ENV N8N_BASIC_AUTH_USER=$USERNAME
ENV N8N_BASIC_AUTH_PASSWORD=$PASSWORD
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true

USER node

# COPY ./workflows ./workflows
# COPY ./credentials ./credentials

RUN mkdir -p ~/.n8n/nodes

RUN cd ~/.n8n/nodes && \
    npm install --production --force n8n-nodes-browserless n8n-nodes-evolution-api n8n-nodes-globals

# RUN n8n import:workflow --separate --input=./workflows/
# RUN n8n update:workflow --all --active=true
# RUN n8n import:credentials --separate --input=./credentials

CMD ["n8n", "start"]
