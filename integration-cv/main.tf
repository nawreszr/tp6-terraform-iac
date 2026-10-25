terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {} # Utilise le Docker local de la VM

variable "external_port" {
  type = number
}

resource "docker_image" "cv" {
  name         = "cv-one-page:latest"
  keep_locally = true
  build {
    context = "/opt/cv"
  }
}

resource "docker_container" "cv" {
  image = docker_image.cv.image_id
  name  = "cv_container"
  ports {
    internal = 80
    external = var.external_port
  }
}
