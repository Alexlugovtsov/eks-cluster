# https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack
resource "helm_release" "prometheus-community" {
  name = "kube-prometheus-stack"
  version = "45.26.0"

  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  create_namespace = true
  namespace  = "monitoring"
  depends_on  = [module.lb_role,aws_eks_node_group.managed_group]

values = [
  <<-EOF
prometheus-node-exporter:
  hostRootFsMount:
    enabled: false
grafana:
  adminPassword: school
  service:
    type: NodePort
  ingress:
    enabled: true
    annotations:
      kubernetes.io/ingress.class: alb
      #kubernetes.io/tls-acme: "true"
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/healthcheck-path: /api/health
      alb.ingress.kubernetes.io/group.name: ${var.cluster_name}
      #alb.ingress.kubernetes.io/certificate-arn: aws_acm_certificate.cert.arn
      #alb.ingress.kubernetes.io/ssl-redirect: '443'
      #alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    hosts:
    - grafana.${var.cluster_name}.${var.hosted_zone}
    - ${aws_lb.default.dns_name}

  EOF
]
}