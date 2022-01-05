output "id1" {
   value = random_uuid.id1.result
}

output "pet-name" {
  value = random_pet.my-pet.id
}