resource "gitlab_project" "first_one" {
  name        = "first_one"
  description = "Some informative description."

  visibility_level = "private"
  default_branch = "master"
  only_allow_merge_if_pipeline_succeeds = true
}


resource "gitlab_service_slack" "slack" {
  project                    = gitlab_project.first_one.id
  webhook                    = "https://webhook.com"
  username                   = "myuser"
  push_events                = true
  push_channel               = "dmvp_push_chan"
}