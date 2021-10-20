```hcl
module route53-health-check-to-slack {
    source = ".dasmeta/modules/aws//modules/route53-health-checks"
    domen_name      = "exemple.com"
    slack_hook_url  = "/services/T86984594/B02J5AK41A8/ksjdhfksdjhKJHGJKHGJK"
    
}

```