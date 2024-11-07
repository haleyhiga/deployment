#!/bin/bash

# Usage:
# ./deploy.sh deploy <docker_username>   # To build, push images and deploy resources
# ./deploy.sh teardown                   # To tear down resources

ACTION=$1
DOCKER_USERNAME=$2

function build_and_push_images() {
    echo "Building Docker images..."

    # Build frontend image
    docker build -t $DOCKER_USERNAME/plannerfrontend:latest ./client
    # Build backend image
    docker build -t $DOCKER_USERNAME/plannerbackend:latest ./server

    echo "Pushing Docker images to Docker Hub..."
    docker push $DOCKER_USERNAME/plannerfrontend:latest
    docker push $DOCKER_USERNAME/plannerbackend:latest
}

function update_deployment_files() {
    echo "Updating deployment files with Docker images..."

    # Backup original files
    cp backend-deployment.yaml backend-deployment.yaml.bak
    cp frontend-deployment.yaml frontend-deployment.yaml.bak

    # Replace image names in deployment files
    sed -i "s|image: .*$|image: $DOCKER_USERNAME/plannerbackend:latest|g" backend-deployment.yaml
    sed -i "s|image: .*$|image: $DOCKER_USERNAME/plannerfrontend:latest|g" frontend-deployment.yaml
}

function restore_deployment_files() {
    echo "Restoring original deployment files..."

    # Restore original files
    mv backend-deployment.yaml.bak backend-deployment.yaml
    mv frontend-deployment.yaml.bak frontend-deployment.yaml
}

function deploy() {
    build_and_push_images
    update_deployment_files

    echo "Deploying resources..."
    kubectl apply -f deploy.yaml
    kubectl apply -f backend-deployment.yaml
    kubectl apply -f frontend-deployment.yaml
    kubectl apply -f ingress.yaml

    restore_deployment_files
    echo "Deployment complete."
}

function teardown() {
    echo "Tearing down resources..."
    kubectl delete -f ingress.yaml
    kubectl delete -f frontend-deployment.yaml
    kubectl delete -f backend-deployment.yaml
    kubectl delete -f deploy.yaml
    echo "Teardown complete."
}

case "$ACTION" in
  deploy)
    if [ -z "$DOCKER_USERNAME" ]; then
      echo "Usage: $0 deploy <docker_username>"
      exit 1
    fi
    deploy
    ;;
  teardown)
    teardown
    ;;
  *)
    echo "Usage: $0 {deploy|teardown} [docker_username]"
    exit 1
    ;;
esac
