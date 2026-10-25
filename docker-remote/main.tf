terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  # Connexion à Docker sur la VM distante via SSH
  host = "ssh://workerdevops@192.168.201.128:22"
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = "nginx_remote_terraform"
  ports {
    internal = 80
    external = 8003
  }
}
