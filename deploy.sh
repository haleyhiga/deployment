#!/bin/bash

# Prompt for Docker username if not set
if [ -z "$DOCKER_USERNAME" ]; then
  read -p "Enter your Docker username: " DOCKER_USERNAME
fi

# Ask if the user wants to rebuild Docker images
read -p "Do you want to rebuild Docker images? (y/n): " rebuild_choice
if [ "$rebuild_choice" == "y" ]; then
  echo "Building Docker images..."
  # Build frontend image
  (cd ./client && docker build -t $DOCKER_USERNAME/plannerfrontend:latest .)
  # Build backend image
  (cd ./server && docker build -t $DOCKER_USERNAME/plannerbackend:latest .)
  echo "Pushing Docker images to Docker Hub..."
  docker push $DOCKER_USERNAME/plannerfrontend:latest
  docker push $DOCKER_USERNAME/plannerbackend:latest
  echo "Updating deployment files with Docker images..."
  # Backup original files
  cp backend-deployment.yaml backend-deployment.yaml.bak
  cp frontend-deployment.yaml frontend-deployment.yaml.bak
  # Replace image names in deployment files
  sed -i "s|image: .*$|image: $DOCKER_USERNAME/plannerbackend:latest|g" backend-deployment.yaml
  sed -i "s|image: .*$|image: $DOCKER_USERNAME/plannerfrontend:latest|g" frontend-deployment.yaml
  UPDATE_YAMLS=true
else
  echo "Skipping Docker image rebuild."
fi

# Ask if the user wants to deploy the resources
read -p "Do you want to deploy the resources? (y/n): " deploy_choice
if [ "$deploy_choice" == "y" ]; then
  echo "Deploying resources..."
  kubectl apply -f contour.yaml
  kubectl apply -f ingress.yaml
  kubectl apply -f backend-deployment.yaml
  kubectl apply -f frontend-deployment.yaml

  # Restore original YAML files if they were modified
  if [ "$UPDATE_YAMLS" == "true" ]; then
    echo "Restoring original deployment files..."
    mv backend-deployment.yaml.bak backend-deployment.yaml
    mv frontend-deployment.yaml.bak frontend-deployment.yaml
  fi

  echo "Deployment complete."
else
  echo "Skipping deployment."
fi

# Optionally delete resources
read -p "Do you want to delete the deployed resources? (y/n): " delete_choice
if [ "$delete_choice" == "y" ]; then
  echo "Deleting resources..."
  kubectl delete -f backend-deployment.yaml
  kubectl delete -f frontend-deployment.yaml
  read -p "Do you want to remove the ingress projectcontour? (y/n): " contour_choice
  if [ "$contour_choice" == "y" ]; then
    kubectl delete -f contour.yaml
    kubectl delete -f ingress.yaml
  fi
  echo "Deletion complete."
else
  echo "Resources not deleted."
fi