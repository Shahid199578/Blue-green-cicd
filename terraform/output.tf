output "eks_cluste_name" {
  description = "The name of EKS cluster"
  value       = aws_eks_cluster.demo.name
}


output "eks_cluste_endpoint" {
  description = "The endpoint of EKS cluster"
  value       = aws_eks_cluster.demo.endpoint
}

output "eks_cluste_arn" {
  description = "The arn of EKS cluster"
  value       = aws_eks_cluster.demo.arn
}

output "kubeconfig" {
  description = "command to update kubeconfig"
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.demo.name} --region ${var.region}"
}