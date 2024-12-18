output "salt_master_public_ip" {
  value = module.cluster.salt_master_public_ip
}

output "hostclass_list" {
  value = var.hostclass
}

output "branch" {
  value = var.branch
}

output "cluster_type" {
  value = var.cluster_type
}

output "repository_source" {
  value = var.repository_source
}

output "region" {
  value = var.region
}

output "private_key_file" {
  value = var.private_key_file
}

output "public_ips" {
  value = module.cluster.public_ips
}

output "hostmap" {
  value = module.cluster.hostmap
}
