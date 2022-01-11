resource "tls_private_key" "pvtkey" {
  algorithm = "RSA"
  rsa_bits = 4096
  # depends_on = [
  #   local_file.key_details
  # ]
}

resource "local_file" "key_details" {
  filename = "key.txt"
  content = tls_private_key.pvtkey.private_key_pem
}