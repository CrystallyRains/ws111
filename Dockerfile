# Use the latest Ubuntu base image
FROM ubuntu:latest

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    fortune-mod \       
    cowsay \            
    netcat-openbsd \    
    && rm -rf /var/lib/apt/lists/*

# Copy the wisecow.sh script to the container at /app directory
COPY wisecow.sh .

# Make the script executable (change permissions to a more secure setting)
RUN chmod +x wisecow.sh

# Expose the port 4499 on which the application listens
EXPOSE 4499

# Define the command to run the application when the container starts
CMD ["./wisecow.sh"]
