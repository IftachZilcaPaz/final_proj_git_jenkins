# Use the official Nginx image from the Docker Hub
FROM nginx:alpine

# Copy the HTML file into place
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to the outside once the container has launched
EXPOSE 80
