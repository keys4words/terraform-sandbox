variable "instance_type" {
  description = "default free eligable Amazon linux for my region"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  description = "default free zone"
  type = string
  default = "us-east-1c"
}

variable "ami_type" {
  description = "default free eligable Amazon linux for my region"
  type = string
  default = "ami-04ad2567c9e3d7893" 
}

variable "vm_names" {
  type = list(string)
  default = [ "slave one", "slave two" ]
}