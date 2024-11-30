module "cluster" {
  source            = "../../aws-salt/terraform/modules/aws-cluster-module"
  region            = var.region
  hostclass         = var.hostclass
  cluster_type      = var.cluster_type
  cluster_name      = "${var.cluster_type}-${var.branch}"
  repository_source = var.repository_source
  branch            = var.branch
}
