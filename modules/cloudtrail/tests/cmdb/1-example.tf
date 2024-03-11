module "this" {
  source = "../../"

  name = "audit-log-cloudtrail-1234"

  event_selector = [{
    read_write_type           = "WriteOnly"
    include_management_events = true
    data_resource             = []
  }]
  cmdb_integration = {
    enabled = true
  }
}
