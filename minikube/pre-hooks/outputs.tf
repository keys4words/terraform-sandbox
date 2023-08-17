output "ns_name" {
    description = "Name of created namespace"
    value       = kubernetes_namespace.ns.id
}

output "ns_uid" {
    description = "UID of created namespace"
    value = kubernetes_namespace.ns.metadata[0].uid
}

output "roles" {
    description = "Name of role"
    value       = kubernetes_role.role
}

output "rolebinds" {
    description = "Rolebinds"
    value       = kubernetes_role_binding.rolebind
}

output "quotas" {
    description = "Quotas"
    value = kubernetes_resource_quota.quota
}