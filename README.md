```
docker build --platform linux/amd64 -t n8n .
docker tag n8n fdelpozo/n8n:1.74.1    
docker push --platform linux/amd64 fdelpozo/n8n:1.74.1  
```