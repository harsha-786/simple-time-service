
variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "default"
}

variable "app_image" {
  description = "Docker image to run"
  type        = string
  default     = "harsha786docker/simple-time-service:1.0.1"
}

variable "container_port" {
  description = "Container port exposed by the app"
  type        = number
  default     = 8080
}

variable "desired_count" {
  description = "Number of ECS tasks"
  type        = number
  default     = 2
}

variable "instance_cpu" {
  description = "Fargate CPU units"
  type        = number
  default     = 256
}

variable "instance_memory" {
  description = "Fargate memory (MiB)"
  type        = number
  default     = 512
}

variable "ssh_ingress_cidr" {
  description = "(Optional) CIDR allowed to SSH to bastion if you add one later"
  type        = string
  default     = "0.0.0.0/0"
}
