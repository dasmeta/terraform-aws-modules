variable name {
  type        = string
  default     = "Pool name"
  description = "Name of the pool that will be created"
}

variable clients {
  type        = list(string)
  description = "List of client names"
}
