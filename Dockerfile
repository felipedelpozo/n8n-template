FROM n8nio/n8n

ENV ENABLE_ALPINE_PRIVATE_NETWORKING=true

USER node

COPY ./workflows ./workflows
# COPY ./credentials ./credentials

RUN mkdir -p ~/.n8n/nodes

RUN cd ~/.n8n/nodes && \
    npm install --production --force n8n-nodes-browserless n8n-nodes-evolution-api n8n-nodes-globals

RUN n8n import:workflow --separate --input=./workflows/
RUN n8n update:workflow --all --active=true
# RUN n8n import:credentials --separate --input=./credentials

CMD ["n8n", "start"]
