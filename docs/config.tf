#10 primeras lineas es para que use docker
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}
provider "docker" {} # Para Windows, añadir: host = "npipe:////.//pipe//docker_engine"

#imagen del dind
resource "docker_image" "dind" {
  name = "docker:dind"
}

#red de docker
resource "docker_network" "red_docker" {
  name = "red_docker"
}


resource "docker_volume" "jenkins-docker-certs" {
  name = "jenkins-docker-certs"
}

resource "docker_volume" "jenkins-data" {
  name = "jenkins-data"
}


resource "docker_container" "jenkins-docker" {
  image = docker_image.dind.image_id
  name  = "jenkins-docker"
  ports {
    internal = 2376
    external = 2376
  }
  networks_advanced {
    name    = docker_network.red_docker.name
    aliases = ["docker"] #alias del contenedor en la red
  }

  privileged = true
  env = [
    "DOCKER_TLS_CERTDIR=/certs"
  ]

  volumes {
    volume_name    = docker_volume.jenkins-docker-certs.name
    container_path = "/certs/client"
  }

  volumes {
    volume_name    = docker_volume.jenkins-data.name
    container_path = "/var/jenkins_home"
  }

  rm = true
}

resource "docker_container" "jenkins-blueocean" {
  image = "myjenkins-blueocean" #dockerfile
  name  = "jenkins-blueocean"
  ports {
    internal = 8080
    external = 8080
  }
  ports {
    internal = 50000
    external = 50000
  }
  networks_advanced {
    name = docker_network.red_docker.name
  }

  env = [
    "DOCKER_HOST=tcp://docker:2376",
    "DOCKER_CERT_PATH=/certs/client",
    "DOCKER_TLS_VERIFY=1"
  ]

  volumes {
    volume_name    = docker_volume.jenkins-docker-certs.name
    container_path = "/certs/client"
    read_only      = true
  }

  volumes {
    volume_name    = docker_volume.jenkins-data.name
    container_path = "/var/jenkins_home"
  }

  restart = "on-failure"
}