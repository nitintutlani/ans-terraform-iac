output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = module.ans-nginx.alb_dns_name
}
