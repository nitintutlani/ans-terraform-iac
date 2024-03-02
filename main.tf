module "ans-vpc" {
    source  = "./modules/ans-vpc"
    project_name = var.project_name
    public_subnet_count = 3
    private_subnet_count = 3
}

module "ans-nginx" {
    source  = "./modules/ans-nginx"
    project_name = var.project_name
    vpc_id = module.ans-vpc.vpc_id
    instance_count = 2
    instance_type = "t2.micro"
    public_subnet_ids = module.ans-vpc.subnet_ids.public
    public_security_group_id = module.ans-vpc.security_group_id.public
    private_subnet_ids = module.ans-vpc.subnet_ids.private
    private_security_group_id = module.ans-vpc.security_group_id.private
}
