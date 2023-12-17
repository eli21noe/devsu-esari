output "lb_ip" {
  value = "${kubernetes_service.testdevsu_service.metadata.0.name}"
}