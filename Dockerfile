FROM nginx:1.26.2-alpine

# Crear usuario no-root
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copiar archivos
COPY build/web /usr/share/nginx/html

# Cambiar permisos
RUN chown -R appuser:appgroup /usr/share/nginx/html

USER appuser

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
