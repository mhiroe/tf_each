## sa作成
# DH分析者用 saアカウント

resource "google_service_account" "sa-dh-analysts" {
  project = var.project
  # range は 一つ前の数字までを作成する
  for_each   = { for num in range(01, 04) : num => format("%s%02d", "sa-dh-dupf-anl", num) }
  account_id = each.value
}


#  ポリシー設定

# groupに対するrole追加
resource "google_project_iam_member" "desc-analyst-group-policy" {
  project = var.project
  for_each = toset([
    "roles/viewer",
    "roles/bigquery.jobUser",
    "roles/bigquery.readSessionUser",
  ])

  role   = each.value
  member = "group:desc-du-data-analysts-gcp_my@dena.jp"

  depends_on = [google_service_account.sa-dh-analysts]
}



# # グループ memberに saを追加する方法 (iam_memberを使わないやりかた) # カスタムドメインに terraformのプロバイダが対応していない
# # terraform で表現するには iam memberでやるしかない
# 
# resource "google_cloud_identity_group_membership" "dessc-du-data-analysts-gcp_grp_memberships" {
#   provider = google-beta
#   group    = "group:desc-du-data-analysts-gcp_my@dena.jp"

#   for_each = { for sa in google_service_account.sa-dh-analysts : sa.account_id => sa.email }
#   preferred_member_key {
#     id = each.value
#   }

#   roles {
#     name = "MEMBER"
#   }

#   depends_on = [google_service_account.sa-dh-analysts]
# }


