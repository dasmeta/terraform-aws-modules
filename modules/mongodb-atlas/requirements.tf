terraform {
  required_version = "> 0.15.0"

  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.1.1"
    }
  }
}
