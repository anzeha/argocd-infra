resource "htpasswd_password" "hash" {
  password = var.argo_admin_password
}


resource "helm_release" "argocd" {
  depends_on       = [htpasswd_password.hash]
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  create_namespace = true
  namespace        = var.argocd_namespace
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = htpasswd_password.hash.bcrypt
  }
  set {
    name  = "configs.params.server.insecure"
    value = false
  }

  set {
    name  = "server.ingress.enabled"
    value = true
  }

  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
}

resource "kubernetes_ingress_v1" "this" {
  depends_on = [helm_release.argocd]
  count      = var.setup_argocd_ingress ? 1 : 0
  metadata {
    name      = "argocd-server-http-ingress"
    namespace = var.argocd_namespace
    annotations = {
      "kubernetes.io/ingress.class" : "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" : "true"
      "ingress.kubernetes.io/ssl-redirect" : "true"
      "nginx.ingress.kubernetes.io/backend-protocol" : "HTTPS"
    }
  }

  spec {
    rule {

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "argocd-server"
              port {
                name = "http"
              }
            }
          }
        }
      }
    }
  }
}
