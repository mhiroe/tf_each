locals {
  list = [
    "hoge",
    "fuga"
  ]
}

output "output_map" {
  # value = {} の形になっている
  value = {for i, l in local.list : i => l}
}
