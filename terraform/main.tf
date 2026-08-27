module "network" {
  source = "./modules/network"

  name     = "demo-network"
  region   = "us-east-1"
  cidr     = "10.0.0.0/16"
  az_count = 2
}

module "ecr" {
  source = "./modules/ecr"

  name                 = "e71-0351-4e1d-a822-8e90db8812e6"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  force_delete         = false
}


module "eks" {
  source = "./modules/eks"

  # --- Networking: ALWAYS a literal reference to module.network's outputs.
  # Never a Handlebars placeholder, never sourced from the EKS DB config —
  # this is what removes the duplicate-VPC problem from the standalone
  # EKS project.
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids

  # --- Cluster config: sourced from the EKS DB config
  region          = "us-east-1"
  cluster_name    = "demo-cluster"
  cluster_version = "1.35"

  node_groups = {
    general = {
      instance_types = ["c7i-flex.large"]
      capacity_type  = "ON_DEMAND"
      desired_size   = 2
      min_size       = 1
      max_size       = 4
      disk_size      = 20
    }
  }

  names_of_users_cluster_admins = [
    {
      user_name       = "GP"
      user_account_id = "997206200726"
      cluster_name    = "demo-cluster"
    }
  ]

  # Grafana admin password is intentionally NOT embedded here as a literal —
  # it is declared as a sensitive root variable (see variables.generator.js)
  # and populated via terraform.tfvars / environment injection at apply time,
  # so it never sits in plaintext inside main.tf.
  grafana_admin_password = var.grafana_admin_password

  enable_ebs_csi          = true
  enable_alb_controller   = true
  enable_external_dns     = true
  enable_external_secrets = true

  depends_on = [module.network]
}
