module "network" {
  source = "./modules/network"

  name     = "demo-network"
  region   = "us-east-1"
  cidr     = "10.0.0.0/16"
  az_count = 2
}

module "ecr" {
  source = "./modules/ecr"

  name                 = "bf5776c-6e63-469a-ba5c-a2ab7b7e936d"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  force_delete         = false
}


module "vm" {
  source = "./modules/vm"

  # --- Networking: ALWAYS a literal reference to module.network's outputs.
  # Never a Handlebars placeholder, never sourced from the VM DB config —
  # same rule as vpc_id in eks.hbs.
  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_ids[0]

  # --- VM config: sourced from the VmDeployment DB config
  name              = "test"
  region            = "us-east-1"
  instance_type     = "t3.micro"
  kind_cluster_name = "kind"
  container_port    = 3000
  host_port         = 80

  depends_on = [module.network]
}