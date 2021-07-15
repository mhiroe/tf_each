
# sa作ってる時のリスト
# username = accountname ?
locals {
   dh-dupf-anls = {
    "dh-dupf-anl01" = "sa-dh-dupf-anl01"
    "dh-dupf-anl02" = "sa-dh-dupf-anl02"
   }
}

locals {
  dh-dupf-anls-array = [
    "sa-dh-dupf-anl01",
    "sa-dh-dupf-anl02"
  ]
}


# sa-dh のrole
locals {
  dh-dupf-anls_roles = {
    "bj" = "roles/bigquery.jobUser"
    "br" = "roles/bigquery.readSessionUser"
  }
}


# なんか変なリスト作ってる.
locals {
  dh-dupf-anls_roles_members = [
    # for pair in setproduct(keys(local.dh-dupf-anls), values(local.dh-dupf-anls_roles)) : {
    for pair in setproduct(local.dh-dupf-anls-array, values(local.dh-dupf-anls_roles)) : { # arrayでもできる。
      username = pair[0]
      # account = "serviceAccount:${google_service_account.sa[pair[0]].email}"
      account = "serviceAccount:sa-xxxxxxx.email" # 思いっきりsaのリソースに依存している
      role    = pair[1]
      # what    = pair[3] # 配列の3つめはない
    }
  ]
}

# setproduct とは
# 多分 (A B)  * (1 2) = A1 A2 B1 B2 って感じ。
# https://www.terraform.io/docs/language/functions/setproduct.html

# pair[0] ->  dh-dupf-anls のkey が入る っていうか、出力は配列かよ


output "kaoss" {
  # value = [for i in local.dh-dupf-anls_roles_members : l ]
  value = local.dh-dupf-anls_roles_members 
}

# こういう出力 要は組み合わせを出力してるわけ。
#   + kaoss      = [
#   + {
#       + account  = "serviceAccount:sa-xxxxxxx.email"
#       + role     = "roles/bigquery.jobUser"
#       + username = "dh-dupf-anl01"
#     },
#   + {
#       + account  = "serviceAccount:sa-xxxxxxx.email"
#       + role     = "roles/bigquery.readSessionUser"
#       + username = "dh-dupf-anl01"
#     },
#   + {
#       + account  = "serviceAccount:sa-xxxxxxx.email"
#       + role     = "roles/bigquery.jobUser"
#       + username = "dh-dupf-anl02"
#     },
#   + {
#       + account  = "serviceAccount:sa-xxxxxxx.email"
#       + role     = "roles/bigquery.readSessionUser"
#       + username = "dh-dupf-anl02"
#     },
# ]