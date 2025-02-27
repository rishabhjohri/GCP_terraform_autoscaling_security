resource "google_project_iam_member" "viewer" {
  project = "peaceful-bruin-450521-c6"
  role    = "roles/viewer"
  member  = "user:m23csa020@iitj.ac.in"
}
