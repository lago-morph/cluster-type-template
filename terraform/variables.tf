variable "branch" {
  description = "current branch of the current git repository"
}

variable "hostclass" {
  description = "hostclass object from cluster.json config file"
}

variable "cluster_type" {
  type        = string
  description = "cluster_type key from cluster-type.json config file"
}

variable "repository_source" {
  type        = string
  description = "repository_source key from cluster-type.json config file"
}

variable "region" {
  type        = string
  description = "region key from cluster-type.json config file"
}

variable "private_key_file" {
  type        = string
  description = "private_key_file key from cluster-type.json config file (not used)"
}

