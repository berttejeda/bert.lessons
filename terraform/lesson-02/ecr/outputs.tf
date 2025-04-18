output "ecr_repo_name" {
  description = "The name of the docker image repo for the ECS service"
  value = aws_ecr_repository.ecr_repo.name
}