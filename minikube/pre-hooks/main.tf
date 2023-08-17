provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = var.name_of_ns
  }
}

resource "kubernetes_resource_quota" "quota" {
  for_each = tomap(var.resource_quotas)
  metadata {
    name      = each.value.metadata.name
    namespace = var.name_of_ns
  }

  spec {
    hard    = each.value.spec.hard
    scopes  = each.value.spec.scopes
    scope_selector {
      match_expression {
        operator    = each.value.spec.scopeSelector.matchExpressions["0"].operator
        scope_name  = each.value.spec.scopeSelector.matchExpressions["0"].scopeName
        values      = each.value.spec.scopeSelector.matchExpressions["0"].values
      }
    }
  }
}

resource "kubernetes_role" "role" {
  for_each = tomap(var.roles)
  metadata {
    name      = each.value.metadata.name
    namespace = var.name_of_ns
    labels    = each.value.metadata.labels
  }

  dynamic "rule" {
    for_each = [for r in each.value["rules"]:{
      api_groups      = r.api_groups
      resources       = r.resources
      resource_names  = r.resource_names
      verbs           = r.verbs
    }]
    content {
      api_groups      = rule.value.api_groups
      resources       = rule.value.resources
      resource_names  = rule.value.resource_names
      verbs           = rule.value.verbs
    }
  }
}

resource "kubernetes_role_binding" "rolebind" {
  for_each = tomap(var.rolebinds)
  metadata {
    name      = each.value.metadata.name
    namespace = var.name_of_ns
  }

  role_ref {
    api_group = each.value.role_ref.api_group
    kind      = each.value.role_ref.kind
    name      = each.value.role_ref.name
  }

  dynamic "subject" {
    for_each = [for s in each.value["subjects"] : {
      kind      = s.kind
      name      = s.name
      api_group = s.api_group
      namespace = s.namespace
    }]
    content {
      kind      = subject.value.kind
      name      = subject.value.name
      api_group = subject.value.api_group
      namespace = subject.value.namespace
    }
  }
}