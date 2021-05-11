resource "random_string" "bootstrap_token_id" {
  length  = 6
  lower   = true
  number  = true
  special = false
  upper   = false
}

resource "random_string" "bootstrap_token_secret" {
  length  = 16
  lower   = true
  number  = true
  special = false
  upper   = false
}
