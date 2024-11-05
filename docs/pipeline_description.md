# Jenkins Pipeline Script Description

This document describes the Jenkins pipeline script used to automate the deployment of a WordPress and MySQL application using Docker. The pipeline includes stages for building Docker images, running containers, checking their status, and testing the deployment.

## Pipeline Overview

The pipeline is designed to run on any available Jenkins agent and comprises several stages, each serving a specific purpose.

### 1. Environment Variables

Before any stages begin, environment variables are set up for MySQL credentials and database configurations. These variables are sourced from Jenkins credentials:

- **MYSQL_ROOT_PASSWORD**: Root password for MySQL (sourced from Jenkins credentials).
- **MYSQL_DATABASE**: Name of the database to be created (set to "wordpress").
- **MYSQL_USER**: User for the database (set to "wpuser").
- **MYSQL_PASSWORD**: Password for the MySQL user (sourced from Jenkins credentials).

### 2. Build Docker Images Stage

In this stage, Docker images for WordPress and MySQL are built:

- **Commands Used**:
    - `docker build -t mywordpress-image -f /home/ubuntu/DOCKERFILE.wordpress /home/ubuntu`
    - `docker build -t mymysql-image -f /home/ubuntu/DOCKERFILE.mysql /home/ubuntu`

- **Outcome**: Two Docker images are created: `mywordpress-image` and `mymysql-image`.

### 3. Run MySQL Container Stage

This stage runs a MySQL container using the previously built MySQL image:

- **Docker Run Command**:
    ```bash
    docker run -d --name mysql_container \
        -e MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD \
        -e MYSQL_DATABASE=$MYSQL_DATABASE \
        -e MYSQL_USER=$MYSQL_USER \
        -e MYSQL_PASSWORD=$MYSQL_PASSWORD \
        mymysql-image
    ```

- **Outcome**: A detached MySQL container named `mysql_container` is created and started, using the defined environment variables.

### 4. Run WordPress Container Stage

In this stage, a WordPress container is started, linked to the MySQL container:

- **Docker Run Command**:
    ```bash
    docker run -d --name wordpress_container \
        --link mysql_container:mysql \
        -e WORDPRESS_DB_HOST=mysql:3306 \
        -e WORDPRESS_DB_USER=$MYSQL_USER \
        -e WORDPRESS_DB_PASSWORD=$MYSQL_PASSWORD \
        -e WORDPRESS_DB_NAME=$MYSQL_DATABASE \
        -p 80:80 \
        mywordpress-image
    ```

- **Outcome**: A detached WordPress container named `wordpress_container` is created, linked to `mysql_container`, and mapped to port 80 on the host.

### 5. Check Container Status Stage

This stage verifies that the Docker containers are running:

- **Command Used**:
    ```bash
    docker ps
    ```

- **Outcome**: The currently running containers are listed, allowing you to confirm that both the MySQL and WordPress containers are active.

### 6. Check WordPress Logs Stage

Logs from the WordPress container are displayed for debugging purposes:

- **Command Used**:
    ```bash
    docker logs wordpress_container
    ```
- **Outcome**: The logs provide insights into the WordPress container's behavior, including any errors or status messages.

### 7. Test Deployment Stage

This stage tests the deployment by checking if the WordPress application is accessible via HTTP:

- **Commands Used**:
    ```bash
    sleep 50
    curl -IL http://43.205.237.11:80/ | grep "200 OK" || exit 1
    ```

- **Outcome**: The script waits for 50 seconds (allowing time for the containers to initialize) and then makes a HEAD request to the WordPress URL. If a "200 OK" response is not received, the pipeline fails.

## Post Actions

Regardless of the pipeline outcome, a message is printed:

- **Message**: 'WordPress is up and running!'
This serves as confirmation that the pipeline execution has completed, and it provides a summary status.

## Conclusion

This Jenkins pipeline script automates the deployment of a WordPress and MySQL application using Docker, streamlining the development workflow and ensuring consistent application deployment. For more information on setting up this pipeline, refer to the [Setup Instructions](setup_instructions.md).

