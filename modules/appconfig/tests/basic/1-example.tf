module "this" {
  source = "../.."

  name = "test application"
  environments = [
    {
      name        = "development"
      description = "Development environment, used by developers"
      deploys = [
        {
          config   = "CheckoutProfile"
          strategy = "custom-strategy"
          version  = "1"
        },
      ]
    },
    {
      name = "test"
      deploys = [
        {
          config   = "CheckoutProfile"
          strategy = "custom-strategy"
          version  = "2"
        },
      ]
    },
  ]

  configs = [
    {
      name    = "CheckoutProfile"
      version = "1"
      flags = [
        {
          name    = "allow-bitcoin-at-checkout"
          enabled = true
          attributes = [
            {
              name  = "bitcoin-discount-end-date"
              type  = "string"
              value = "06/05/2023"
            },
            {
              name  = "bitcoin-discount-percentage"
              type  = "number"
              value = "5"
            },
            {
              name  = "default-currency"
              type  = "string"
              value = "BTC"
            },
          ]
        }
      ],
    },
    {
      name    = "CheckoutProfile"
      version = "2"
      flags = [
        {
          name    = "allow-bitcoin-at-checkout"
          enabled = false
          attributes = [
            {
              name  = "bitcoin-discount-end-date"
              type  = "string"
              value = "06/05/2023"
            },
            {
              name  = "bitcoin-discount-percentage"
              type  = "number"
              value = "5"
            },
            {
              name  = "default-currency"
              type  = "string"
              value = "BTC"
            },
          ]
        }
      ],
    },
  ]

  deployment_strategies = [
    {
      name                           = "custom-strategy"
      deployment_duration_in_minutes = 0
      final_bake_time_in_minutes     = 0
      growth_factor                  = 100
    }
  ]
}
