@echo off
echo Creating Terraform project folder...
mkdir "C:\Users\risha\OneDrive\Desktop\vcc_ass2\terraform-gcp"

echo Changing directory to terraform-gcp...
cd "C:\Users\risha\OneDrive\Desktop\vcc_ass2\terraform-gcp"

echo Creating Terraform configuration files...

(
echo provider "google" {
echo   project     = "peaceful-bruin-450521-c6"
echo   region      = "us-central1"
echo   credentials = file("terraform-key.json")
echo }
) > provider.tf

(
echo resource "google_compute_instance" "vm" {
echo   name         = "my-vm-instance"
echo   machine_type = "e2-standard-2"
echo   zone         = "us-central1-a"
echo 
echo   boot_disk {
echo     initialize_params {
echo       image = "debian-cloud/debian-11"
echo     }
echo   }
echo 
echo   network_interface {
echo     network = "default"
echo     access_config {
echo     }
echo   }
echo }
) > compute_instance.tf

(
echo resource "google_compute_autoscaler" "vm_autoscaler" {
echo   name   = "vm-autoscaler"
echo   target = google_compute_instance.vm.id
echo   zone   = "us-central1-a"
echo 
echo   autoscaling_policy {
echo     max_replicas    = 5
echo     min_replicas    = 1
echo     cooldown_period = 60
echo     cpu_utilization {
echo       target = 0.6
echo     }
echo   }
echo }
) > autoscaler.tf

(
echo resource "google_compute_firewall" "allow_http" {
echo   name    = "allow-http"
echo   network = "default"
echo 
echo   allow {
echo     protocol = "tcp"
echo     ports    = ["80"]
echo   }
echo 
echo   source_ranges = ["0.0.0.0/0"]
echo   target_tags   = ["web-server"]
echo }
) > firewall.tf

(
echo resource "google_project_iam_member" "viewer" {
echo   project = "peaceful-bruin-450521-c6"
echo   role    = "roles/viewer"
echo   member  = "user:m23csa020@iitj.ac.in"
echo }
) > iam.tf

(
echo variable "project_id" {
echo   type    = string
echo   default = "peaceful-bruin-450521-c6"
echo }
echo variable "region" {
echo   type    = string
echo   default = "us-central1"
echo }
) > variables.tf

(
echo project_id = "peaceful-bruin-450521-c6"
echo region = "us-central1"
) > terraform.tfvars

echo Creating empty terraform-key.json (Manually replace this with your service account JSON)...
type nul > terraform-key.json

echo All Terraform files have been created successfully in "C:\Users\risha\OneDrive\Desktop\vcc_ass2\terraform-gcp"
pause
