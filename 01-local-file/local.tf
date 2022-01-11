resource "local_file" "pet" {
  filename = "pets.txt"
  content = "Hey, dude!"
  file_permission = "0700"
}