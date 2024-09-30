resource "kubernetes_secret_v1" "git_creds" {
  count      = var.argo_image_updater ? 1 : 0
  depends_on = [helm_release.argo_apps]
  metadata {
    name      = "repo-deploy-key"
    namespace = var.argocd_namespace
  }

  data = {
    username = "anzeha"
    password = var.github_token
  }
  type = "Opaque"
}

resource "helm_release" "argo_image_updater" {
  count            = var.argo_image_updater ? 1 : 0
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  create_namespace = true
  namespace        = var.argocd_namespace

  depends_on = [helm_release.argo_apps]

  values = [
    var.argo_image_updater_values
  ]
}