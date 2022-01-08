resource "local_file" "pet" {
  filename = each.value
  for_each = toset(var.filename)
}