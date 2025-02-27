resource "google_compute_instance_template" "vm_template" {
  name         = "vm-template"
  machine_type = "e2-standard-2"
  region       = "us-central1"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = "default"
    access_config {}  # Assigns public IP
  }
}

resource "google_compute_instance_group_manager" "vm_group" {
  name               = "vm-group"
  base_instance_name = "my-instance"
  zone              = "us-central1-a"
  target_size       = 1  # Can be increased by autoscaler
  version {
    instance_template = google_compute_instance_template.vm_template.self_link
  }
}
