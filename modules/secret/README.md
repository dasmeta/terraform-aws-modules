# How to use

## Example usage 1 (when the secret is a value)
module test-secret {
  source  = "dasmeta/modules/aws//modules/cloudwatch"

  name = "test-secret"
  value = "test-secret-value"
}

``
## Example usage 2 (when the secret is a key-value pair)
module test-secret {
  source  = "dasmeta/modules/aws//modules/cloudwatch"

  name = "test-secret"
  value = {
    "key1": "value1"
    "key2": "value2"
    "key3": "value3"
  }
}
