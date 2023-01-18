module "this" {
  source = "../../"

  name = "audit"

  event_selector = [{
    read_write_type           = "WriteOnly"
    include_management_events = true
    data_resource             = []
  }]
  enable_cmdb_integration = true
}
