# Virtual Machine Deployment with Auto-Scaling and Security in GCP

## Overview
This project demonstrates the setup of a **Virtual Machine (VM) on Google Cloud Platform (GCP)** using **Google Cloud CLI and Terraform**. The implementation includes:
- **Auto-Scaling policies** based on CPU utilization.
- **Firewall rules** for securing the VM.
- **IAM role configurations** for restricted access.

## Architecture
![Architecture Diagram](link_to_your_architecture_diagram)

## Technologies Used
- **Google Cloud Platform (GCP)**
- **Google Cloud CLI (gcloud)**
- **Terraform**
- **IAM (Identity and Access Management)**
- **VPC Firewall Rules**
- **Managed Instance Groups**

---

## 📌 Setup Instructions

### 1️⃣ Install Google Cloud CLI
Download and install the Google Cloud CLI:
```
(New-Object Net.WebClient).DownloadFile("https://dl.google.com/dl/cloudsdk/channels/rapid/GoogleCloudSDKInstaller.exe", "$env:Temp\GoogleCloudSDKInstaller.exe")
& $env:Temp\GoogleCloudSDKInstaller.exe
```
After installation, run:
```
gcloud init
```

### 2️⃣ Set Up the GCP Project
```
gcloud config set project peaceful-bruin-450521-c6
gcloud services enable compute.googleapis.com iam.googleapis.com
```

---

## 🚀 Implementation Steps

### 1️⃣ Creating a VM Instance
Using Google Cloud CLI:
```
gcloud compute instances create my-instance \
  --zone=us-central1-a \
  --machine-type=e2-standard-2 \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --network=default
```

Using Terraform (`compute_instance.tf`):
```
resource "google_compute_instance" "vm" {
  name         = "my-vm-instance"
  machine_type = "e2-standard-2"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}  # Assigns public IP
  }
}
```

### 2️⃣ Configuring Auto-Scaling
Using Google Cloud CLI:
```
gcloud compute instance-groups managed set-autoscaling vm-group \
  --zone=us-central1-a \
  --max-num-replicas=5 \
  --min-num-replicas=1 \
  --target-cpu-utilization=0.6
```

Using Terraform (`autoscaler.tf`):
```
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
```

### 3️⃣ Setting Up Firewall Rules
Using Google Cloud CLI:
```
gcloud compute firewall-rules create allow-http \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:80 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=web-server
```

Using Terraform (`firewall.tf`):
```
resource "google_compute_firewall" "allow_http" {
  name    = "allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["web-server"]
}
```

### 4️⃣ IAM Role Configuration
Using Google Cloud CLI:
```
gcloud projects add-iam-policy-binding peaceful-bruin-450521-c6 \
  --member="user:m23csa020@iitj.ac.in" \
  --role="roles/viewer"
```

Using Terraform (`iam.tf`):
```
resource "google_project_iam_member" "viewer" {
  project = "peaceful-bruin-450521-c6"
  role    = "roles/viewer"
  member  = "user:m23csa020@iitj.ac.in"
}
```

---

## ✅ Deployment

### Using Terraform:
1. **Initialize Terraform**
   ```
   terraform init
   ```
2. **Plan the Deployment**
   ```
   terraform plan
   ```
3. **Apply the Configuration**
   ```
   terraform apply -auto-approve
   ```

### Using Google Cloud CLI:
Follow the step-by-step commands mentioned above.

---

## 📌 Testing & Validation
### ✅ Verify Auto-Scaling:
Run a high CPU load inside the VM to test scaling:
```
sudo apt update && sudo apt install -y stress
stress --cpu 2 --timeout 300
```
Check the **Instance Groups** in GCP Console to see if new instances are created.

### ✅ Test HTTP Access:
1. Get the external IP of the VM:
   ```
   gcloud compute instances list
   ```
2. Open the browser and enter:
   ```
   http://<VM_EXTERNAL_IP>
   ```

If **NGINX is not installed**, run:
```
sudo apt update && sudo apt install -y nginx
sudo systemctl start nginx
```

---

## 🔧 Troubleshooting
| Issue | Solution |
|-------|----------|
| Auto-scaling not working | Ensure the target instance group is linked correctly. |
| VM not accessible via HTTP | Verify firewall rule `allow-http` is created. |
| Permission denied on GCP | Check IAM roles and add necessary permissions. |

---

## 📜 Deliverables
- **📄 Documentation**: Step-by-step setup guide.
- **🖼 Architecture Design**: [Link to Diagram](link_to_your_architecture_diagram)
- **💾 Source Code**: [GitHub Repository](link_to_your_repo)
- **📹 Video Demo**: [Link to Video](link_to_your_video)

---

## 📌 Cleanup
To avoid extra billing:
```
terraform destroy -auto-approve
```
OR manually delete instances via:
```
gcloud compute instances delete my-instance --zone=us-central1-a
```

---

