resource "kubernetes_namespace_v1" "floorball_fantasy_namespace" {
  count = var.deploy_app ? 1 : 0
  metadata {
    name = "floorball-fantasy"
  }
}

resource "helm_release" "argo_apps" {
  count            = var.argo_apps ? 1 : 0
  depends_on       = [htpasswd_password.hash, helm_release.argocd]
  name             = "argocd-apps"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  create_namespace = true
  namespace        = var.argocd_namespace
  version          = "0.0.8"

  values = var.deploy_app ? [
    var.argo_apps_values
  ] : []
}