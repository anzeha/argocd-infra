locals {
  roles = [
    "roles/secretmanager.secretAccessor",
    "roles/iam.serviceAccountTokenCreator"
  ]
}

# Add GCP service account
resource "google_service_account" "es-workload-identity-user-sa" {
  account_id   = var.external_secrets_gcp_sa_name
  display_name = "Service Account For Workload Identity of external-secrets"
}

resource "google_project_iam_member" "cluster_service_account_members" {
  for_each = toset(compact(distinct(concat(local.roles))))
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.es-workload-identity-user-sa.email}"
}

# Add workload identity to bind gcp service account to k8s service account
resource "google_project_iam_member" "workload-identity-role" {
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${var.project_id}.svc.id.goog[${var.external_secrets_namespace}/${var.external_secrets_ks_sa_name}]"
  project = var.project_id
}



resource "helm_release" "external_secrets_operator" {
  depends_on       = [helm_release.argocd]
  name             = "external-secrets"
  repository       = "https://charts.external-secrets.io"
  chart            = "external-secrets"
  create_namespace = true
  namespace        = var.external_secrets_namespace

  set {
    name  = "serviceAccount.name"
    value = var.external_secrets_ks_sa_name
  }

  set {
    name  = "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"
    value = "${var.external_secrets_gcp_sa_name}@${var.project_id}.iam.gserviceaccount.com"
  }

}

resource "kubernetes_manifest" "gcp_secrets" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ClusterSecretStore"
    metadata = {
      name = "gcp-secrets"
    }
    spec = {
      provider = {
        gcpsm = {
          projectID = var.project_id
        }
      }
    }
  }
}