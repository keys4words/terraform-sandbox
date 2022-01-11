resource "local_file" "pet" {
  filename = var.filename
  content = "My favorite pet is ${random_pet.my-pet.id}"
}

resource "random_pet" "my-pet" {
  prefix = var.prefix[0]
  separator = var.separator
  length = var.length
}

resource "time_static" "time_update" {
}

resource "local_file" "time" {
  filename = "time.txt"
  content = "Time stamp of this file is ${time_static.time_update.id}"
}