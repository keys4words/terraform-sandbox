variable "filename" {
  default = "pets.txt"
}
variable "content" {
  type = map
  default = {
    "key1" = "We love pets!"
    "key2" = "And owe for them"
  }
}
variable "prefix" {
  default = ["Mrs", "Mr", "Sir"]
  type = list
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
variable "password_change" {
  default = true
  type = bool
}
variable "bella" {
  type = object({
    name = string
    color = string
    age = number
    food = list(string)
    favorite_pet = bool
  })
  default = {
    name = "bella"
    color = "brown"
    age = 7
    food = ["fish", "chicken", "tuna"]
    favorite_pet = true
  }
}
variable kitty {
  type = tuple([string, number, bool])
  default = ["cat", 7, true]
}