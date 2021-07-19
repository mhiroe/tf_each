
locals {
  incremental_data_stores = [for ds in ["desc", "dh", "master"] :
    [for num in range(01, 03) : format("%s%02d", ds, num)]
  ]
}


output "incre_data_stores" {
  value = local.incremental_data_stores
}
