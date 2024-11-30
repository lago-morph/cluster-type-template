module "cluster" {
  source       = "../../aws-salt/terraform/modules/aws-cluster-module"
  region       = var.region
  hostclass    = var.hostclass
  cluster_type = var.cluster_type
  cluster_name = "${var.cluster_type}-${var.branch}"
  private_key  = var.private_key
}
