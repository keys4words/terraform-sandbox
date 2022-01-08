resource "local_file" "pet" {
  filename = var.filename[count.index]

  # count = 3
  count = length(var.filename)
}