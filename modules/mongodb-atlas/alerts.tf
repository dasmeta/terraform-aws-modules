resource "mongodbatlas_alert_configuration" "test" {
  project_id = mongodbatlas_project.main.id
  event_type = "REPLICATION_OPLOG_WINDOW_RUNNING_OUT" //The type of event that will trigger an alert.
  enabled    = true // It is not required, but If the attribute is omitted, by default will be false, and the configuration would be disabled. You must set true to enable the configuration.

  notification {
    type_name     = "GROUP" //type of alert notification
    interval_min  = 5 //Number of minutes to wait between successive notifications for unacknowledged alerts that are not resolved. 
    delay_min     = 0 //Number of minutes to wait after an alert condition is detected before sending out the first notification.
    sms_enabled   = false //Flag indicating if text message notifications should be sent.
    email_enabled = true //Flag indicating if email notifications should be sent.
    roles         = ["GROUP_CLUSTER_MANAGER"] //The following roles grant privileges within a project. Accepted values are:
  }

  matcher {
    field_name = "HOSTNAME_AND_PORT" //Name of the field in the target object to match on.
    operator   = "EQUALS" // The operator to test the field’s value. 
    value      = "SECONDARY" //Value to test with the specified operator. 
  }

  threshold = {
    operator    = "LESS_THAN" // Operator to apply when checking the current metric value against the threshold value.
    threshold   = 72 //Threshold value outside of which an alert will be triggered.
    units       = "HOURS" // The units for the threshold value. Depends on the type of metric.
  }
}
