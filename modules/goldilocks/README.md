# todo
- Goldilocks is a Kubernetes controller that provides a dashboard that gives recommendations on how to set your resource requests.

## Usage

# Case 1

The module create Goldilocks installation prerequisites. The module default create the prerequisites.

° vertical-pod-autoscaler configure in the cluster
° metrics-server 

```
module "goldilocks" {
  source               = "dasmeta/modules/aws//modules/goldilocks"
  namespaces           = ["default"]
  create_metric_server = false
  zone_name            = "example.com"
  hostname             = "goldilock.example.com"
  alb_certificate_arn  = "arn:aws:acm:us-east-1:5********68:certificate/1125ea15-****32d1b"
  alb_subnet           = "subnet-0db50f385ceb5e2b2, subnet-0a03324e443e13e56, subnet-08eac866b7bfe2b33"
  userpoolarn          = "arn:aws:cognito-idp:us-east-1:5*******68:userpool/us-east-1_nr*y6"
  userpoolclientid     = "4k1n0gag*fvqa1g"
  userpooldomain       = "goldilock.auth.us-east-1.amazoncognito.com"
}
```

# Case 2

You can disable the prerequisites for the Goldilocks installation if you have already.

```
module "goldilocks" {
  source     = "dasmeta/shared/any//goldilocks"
  
  # You add namespaces for watch recommendations in dashboard.
  namespaces = [ "kube-system" , "goldilocks" ]

  create_vpa_server    = false
  create_metric_server = false
}

```

```
# Port-forward for access the dashboard
kubectl -n goldilocks port-forward svc/goldilocks-dashboard 8080:80 

# Dashborad url
http://localhost:8080/
```
