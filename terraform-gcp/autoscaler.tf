resource "google_compute_autoscaler" "vm_autoscaler" {
  name   = "vm-autoscaler"
  target = google_compute_instance_group_manager.vm_group.id
  zone   = "us-central1-a"

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}
