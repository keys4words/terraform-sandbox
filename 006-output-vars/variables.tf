variable "filename" {
  default = "pets.txt"
}
variable "prefix" {
  default = "Mrs"
  description = "the prefix to be set"
}
variable "separator" {
  default = "."
}
variable "length" {
  default = 2
  type = number
  description = "length of the pet name in words"
}