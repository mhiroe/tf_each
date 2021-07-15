# locals {
#   list = [
#     "hoge",
#     "fuga"
#   ]
# }

# output "output_map" {
#   # value = {} の形になっている
#   value = {for i, l in local.list : i => l}
# }


# variable "audit_list" {
#   al = [
#     {
#       bucket      = "dena-desc-analy-2nd-audit-gcp_audit"
#       sink_sa     = "serviceAccount:p638791559670-593147@gcp-sa-logging.iam.gserviceaccount.com"
#       allowed_sa  = "p638791559670-593147@gcp-sa-logging.iam.gserviceaccount.com"
#     },
#     {
#       bucket      = "dena-desc-du-pf-prod-gcp_audit"
#       sink_sa     = "serviceAccount:p750537285837-313997@gcp-sa-logging.iam.gserviceaccount.com"
#       allowed_sa  = "p750537285837-313997@gcp-sa-logging.iam.gserviceaccount.com"
#     },
#   ]
# }


# output "list-map-constructure" {
#   for_each = var.audit_list
#   value = each.value.bucket
# }


