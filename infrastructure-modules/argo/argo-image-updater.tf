resource "kubernetes_secret_v1" "git_creds" {
  count      = var.argo_image_updater ? 1 : 0
  depends_on = [ helm_release.argocd ]
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
  depends_on = [ helm_release.argocd ]
  count            = var.argo_image_updater ? 1 : 0
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  create_namespace = true
  namespace        = var.argocd_namespace



  values = [
    <<EOT
config:
  registries:
    - name: Docker Hub
      prefix: docker.io
      api_url: https://registry-1.docker.io
      ping: yes
    EOT
  ]

}