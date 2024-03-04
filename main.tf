module "ans-vpc" {
    source  = "./modules/ans-vpc"

    project_name = var.project_name
    cidr = "10.0.0.0/16"
    az_count = var.az_count
}

module "ans-nginx" {
    source  = "./modules/ans-nginx"

    project_name = var.project_name
    vpc_id = module.ans-vpc.vpc_id
    instance_count = var.instance_count
    instance_type = var.instance_type
    public_subnet_ids = module.ans-vpc.subnet_ids.public
    public_security_group_id = module.ans-vpc.security_group_id.public
    private_subnet_ids = module.ans-vpc.subnet_ids.private
    private_security_group_id = module.ans-vpc.security_group_id.private
}
