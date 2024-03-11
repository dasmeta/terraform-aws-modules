resource "helm_release" "mongodb" {
  name = var.name

  chart      = "mongodb"
  repository = "https://raw.githubusercontent.com/bitnami/charts/archive-full-index/bitnami"
  version    = "10.30.12"

  set {
    name  = "auth.rootPassword"
    value = var.root_password
  }

  set {
    name  = "auth.replicaSetKey"
    value = var.replicaset_key
  }

  set {
    name  = "image.tag"
    value = var.image_tag
  }

  set {
    name  = "persistence.size"
    value = var.persistence_size
  }

  dynamic "set" {
    for_each = var.persistence_annotations != null ? [var.persistence_annotations] : []
    content {
      name  = "persistence.annotations.volume\\.beta\\.kubernetes\\.io/storage-class"
      value = var.persistence_annotations
    }
  }

  set {
    name  = "resources.limits.cpu"
    value = var.resources.limits.cpu
  }

  set {
    name  = "resources.limits.memory"
    value = var.resources.limits.memory
  }

  set {
    name  = "resources.requests.cpu"
    value = var.resources.requests.cpu
  }

  set {
    name  = "resources.requests.memory"
    value = var.resources.requests.memory
  }

  dynamic "set" {
    for_each = var.arbiter_resources.limits.cpu != null ? [var.arbiter_resources.limits.cpu] : []
    content {
      name  = "arbiter.resources.limits.cpu"
      value = var.arbiter_resources.limits.cpu
    }
  }

  dynamic "set" {
    for_each = var.arbiter_resources.limits.memory != null ? [var.arbiter_resources.limits.memory] : []
    content {
      name  = "arbiter.resources.limits.memory"
      value = var.arbiter_resources.limits.memory
    }
  }

  dynamic "set" {
    for_each = var.arbiter_resources.requests.cpu != null ? [var.arbiter_resources.requests.cpu] : []
    content {
      name  = "arbiter.resources.requests.cpu"
      value = var.arbiter_resources.requests.cpu
    }
  }

  dynamic "set" {
    for_each = var.arbiter_resources.requests.memory != null ? [var.arbiter_resources.requests.memory] : []
    content {
      name  = "arbiter.resources.requests.memory"
      value = var.arbiter_resources.requests.memory
    }
  }

  set {
    name  = "readinessProbe.initialDelaySeconds"
    value = var.readinessprobe_initialdelayseconds
  }

  set {
    name  = "livenessProbe.initialDelaySeconds"
    value = var.livenessprobe_initialdelayseconds
  }

  set {
    name  = "architecture"
    value = var.architecture
  }

  set {
    name  = "priorityClassName"
    value = var.priority_class_name
  }
}
