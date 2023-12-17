resource "kubernetes_namespace" "sample" {
  metadata {
    annotations = {
      name = "devsu-annotation"
    }

    labels = {
      mylabel = "devsu-label"
    }

    name = "devsu"
  }
}

resource "kubernetes_replication_controller" "testdevsu_service" {
  metadata {
    name = "ms-app-devsu"
    labels = {
      App = "HelloWorldExample"
    }
  }

  spec {
    selector = {
      App = "HelloWorldExample"
    }
    template {
      metadata {
        labels = {
         App = "HelloWorldExample"
        }
        annotations={
         "key1"="value1"
        }
      }
      spec{
        container {
          image = "elizabethsariu/testdevsu:prod"
          name  = "testdevsu"

          env {
            name  = "SPRING_CONFIG_LOCATION"
            value = "/config"  # Directorio donde se montará el ConfigMap en el contenedor
          }

          volume_mount {
            name       = "springboot-config"
            mount_path = "/config"  # Directorio donde se montará el ConfigMap en el contenedor
          }

          port {
            container_port = 8080
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
    
      }
    }
 }

}
resource "kubernetes_service" "testdevsu_service" {
  metadata {
    name = "test-service"
  }
  spec {
    selector = {
      App = "ms-app-devsu"#"${kubernetes_replication_controller.testdevsu_service.metadata.0.labels.App}"
    }
    port {
      name = "http"
      port = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_config_map" "config_map_devsu" {
  metadata {
    name = "springboot-configmap"
    namespace = "devsu"
  }
  data = {
    "application.properties" = <<EOF
     server.port=8080
     logging.level.root=INFO
    EOF
  }
}

resource "kubernetes_persistent_volume" "example" {
  metadata {
    name = "terraform-example"
  }
  spec {
    capacity = {
      storage = "2Gi"
    }
    access_modes = ["ReadWriteMany"]
    persistent_volume_source {
      vsphere_volume {
        volume_path = "/absolute/path"
      }
    }
  }
}