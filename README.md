# Planner

## Resource

**Planner**

Attributes:

- name (string)
- date (string)
- desc (string)
- course (string)
- notes (string)

## Schema

```sql
CREATE TABLE planner (
    id INTEGER PRIMARY KEY,
    name TEXT,
    date TEXT,
    desc TEXT,
    course TEXT,
    notes TEXT
);
```

## REST Endpoints

| Name                         | Method  | Path                        |
|------------------------------|---------|-----------------------------|
| Retrieve homework collection | GET     | /homework                   |
| Retrieve homework member     | GET     | /homework/<int:homework_id> |
| Create homework member       | POST    | /homework                   |
| Update homework member       | PUT     | /homework/<int:homework_id> |
| Delete homework member       | DELETE  | /homework/<int:homework_id> |
| Handle CORS                  | OPTIONS | /homework/<int:homework_id> |

## Deployment Guide

### Building and Pushing Docker Images

To build and push the Docker images for both the frontend and backend applications, use the `deploy.sh` script with your Docker Hub username.

**Prerequisites:**

- Docker installed and running.
- Logged in to Docker Hub (`docker login`).

**Steps:**

Run the deploy script with the deploy option and your Docker Hub username:

```bash
./deploy.sh deploy <docker_username>
```

Replace `<docker_username>` with your actual Docker Hub username.

This script performs the following steps:

- Builds the Docker images for both the frontend and backend using the specified Docker Hub username.
- Pushes the Docker images to Docker Hub.
- Updates the image names in your `backend-deployment.yaml` and `frontend-deployment.yaml` files.
- Applies the Kubernetes deployment and service configurations.
- Restores the original deployment files after deployment.

**Note:** Ensure you are logged in to Docker Hub before running the script:

```bash
docker login
```

### Applying Kubernetes YAML Files

The `deploy.sh` script applies the necessary Kubernetes YAML files:

- `deploy.yaml`: Namespace and necessary roles and bindings.
- `backend-deployment.yaml`: Deployment and service for the backend application.
- `frontend-deployment.yaml`: Deployment and service for the frontend application.
- `ingress.yaml`: Ingress configurations for routing.

To tear down the Kubernetes resources, run:

```bash
./deploy.sh teardown
```

### Updating Hosts File for Local Testing

If you wish to run the application locally and need to map your domain to your local machine's IP address, update your hosts file.

**Example Entry:**

```
<your-machine-ip>  www.example.com
```

Replace `<your-machine-ip>` with your machine's actual IP address.

#### Instructions for Different Operating Systems

**Windows**

1. Open Notepad as an administrator.
2. Navigate to `C:\Windows\System32\drivers\etc`.
3. Open the `hosts` file.
4. Add the following line at the end:

   ```
   <your-machine-ip>  www.example.com
   ```

5. Save the file.

**macOS and Linux**

1. Open a terminal.
2. Edit the hosts file with root privileges:

   ```bash
   sudo nano /etc/hosts
   ```

3. Add the following line at the end:

   ```
   <your-machine-ip>  www.example.com
   ```

4. Save and exit the editor.

**Note:** Modifying the hosts file requires administrative privileges.
