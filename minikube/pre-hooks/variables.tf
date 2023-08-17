variable "name_of_ns" {
  type    = string
  default = "my-first-tf-namespace"
}

variable "resource_quotas" {
  type = map(any)
}

variable "rolebinds" {
  type = map(any)
}

variable "roles" {
  type = map(any)
}