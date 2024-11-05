#!/bin/bash

# Check if the Jenkins container is already running, and remove it if it is
if [[ $(docker ps -a | grep jenkins) ]]; then
    echo "Removing existing Jenkins container before starting"
    docker rm -f jenkins
fi

# Run the Jenkins container
sudo docker run -d \
    -u root \
    -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v jenkins_home:/var/jenkins_home \
    -v /home/ubuntu:/home/ubuntu \
    --name jenkins \
    jenkins/jenkins:lts

# Check if the Jenkins container started successfully
if [[ $(docker ps | grep jenkins) ]]; then
    echo "Jenkins container started"

    # Check if Docker is already installed in the Jenkins container
    if ! docker exec jenkins command -v docker &> /dev/null; then
        echo "Installing Docker inside the Jenkins container"
        docker exec jenkins bash -c "apt-get update && \
            apt-get install -y apt-transport-https ca-certificates curl && \
            curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
            echo 'deb [arch=amd64] https://download.docker.com/linux/debian \$(lsb_release -cs) stable' > /etc/apt/sources.list.d/docker.list && \
            apt-get update && \
            apt-get install -y docker-ce && \
            usermod -aG docker jenkins"

        echo "Docker installed inside Jenkins container"
    else
        echo "Docker is already installed inside the Jenkins container"
    fi
else
    echo "Jenkins container did not start"
fi
