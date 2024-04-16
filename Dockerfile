# Use an official lightweight Python image.
FROM nginx:alpine

# Set the working directory to /usr/share/nginx/html
WORKDIR /usr/share/nginx/html

# Copy the current directory contents into the container at /usr/share/nginx/html
COPY . /usr/share/nginx/html

# Expose port 80 to the outside once the container has launched
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]
