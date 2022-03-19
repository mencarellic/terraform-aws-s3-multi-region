resource "random_pet" "s3-bucket" {
  length    = 2
  separator = "-"
}

resource "random_pet" "contents" {
  count     = 1000
  length    = 3
  separator = "-"
}