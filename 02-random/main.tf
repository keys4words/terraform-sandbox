resource "local_file" "pet_name" {
	    content = "We love pets!"
	    filename = "pets.txt"
}

resource "random_pet" "my-pet" {
  prefix = "Mrs"
  separator = "."
  length = "1"
}

resource "random_string" "iac_random" {
  length = 10
  min_upper = 5
}