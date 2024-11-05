# WordPress and MySQL Docker Setup with CI/CD Pipeline

## Overview
This repository contains Docker configurations for running WordPress and MySQL along with a CI/CD pipeline using Jenkins.

## Deliverables
1. **Source Code**
   - Dockerfiles for WordPress and MySQL.
   - CI/CD pipeline configuration (Jenkinsfile).

2. **Documentation**
   - [Setup Instructions](docs/setup_instructions.md).
   - [CI/CD Pipeline Description](docs/pipeline_description.md).

## Security Considerations
Sensitive data, such as database passwords and credentials, are handled securely using Jenkins credentials. Environment variables are configured in Jenkins to store these sensitive values:

- **MYSQL_ROOT_PASSWORD**: The root password for MySQL, retrieved from Jenkins credentials.
- **MYSQL_PASSWORD**: The password for the MySQL user (`wpuser`), is also retrieved securely.

By using Jenkins credentials, the pipeline ensures that sensitive information is not hard-coded into the scripts, reducing the risk of accidental exposure.

## Getting Started
Please refer to the [Setup Instructions](docs/setup_instructions.md) to get started with running WordPress and MySQL using Docker. Ensure you have configured Jenkins credentials as mentioned in the setup instructions to manage sensitive data securely.

## CI/CD Pipeline
To learn more about the CI/CD pipeline, check the [Pipeline Description](docs/pipeline_description.md).

## Accessing WordPress
Once the deployment is successful, you can access the WordPress UI by navigating to the following IP address in your web browser:

**WordPress UI**: `http://43.205.237.11:80/`

## Snapshots
Here are some snapshots of the WordPress UI:

### WordPress Home Page
![WordPress Home Page](images/wordpress_home.png)

## Conclusion
This repository provides a comprehensive solution for deploying a WordPress application with a MySQL backend using Docker and a Jenkins CI/CD pipeline. Follow the instructions carefully, particularly those related to managing sensitive data securely through Jenkins credentials.

