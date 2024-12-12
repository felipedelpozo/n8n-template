FROM n8nio/n8n

ARG PGPASSWORD
ARG PGHOST
ARG PGPORT
ARG PGDATABASE
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

ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true

USER node

COPY ./workflows ./workflows

RUN mkdir -p ~/.n8n/nodes

RUN cd ~/.n8n/nodes && \
    npm install --production --force n8n-nodes-browserless n8n-nodes-evolution-api n8n-nodes-globals

RUN npx n8n import:workflow --separate --input=./workflows
RUN npx n8n update:workflow --all --active=true

CMD ["n8n", "start"]
