# variable "repositories" {
#   type = map
# }

# # map structure
# # 
# variable "reps" {
# 	type=map
# 	api1-v1 = {
# 	name                 = "api-v1"
# 	image_tag_mutability = "MUTABLE"
# 	scan_on_push         = true
# 	},
# 	api-v2 = {
# 		name                 = "api-v2"
# 		image_tag_mutability = "IMMUTABLE"
# 		scan_on_push         = false
# 	},
# }
# resource "aws_ecr_repository" "main" {
#   for_each = var.repositories

#   name                 = each.value.name
#   image_tag_mutability = each.value.image_tag_mutability
#   image_scanning_configuration {
#     scan_on_push = each.value.scan_on_push
#   }
# }



# # from calling

# module "ecr" {
#   source = "../../modules/ecr"

#   repositories = {
#     api1-v1 = {
#       name                 = "api-v1"
#       image_tag_mutability = "MUTABLE"
#       scan_on_push         = true
#     },
#     api-v2 = {
#       name                 = "api-v2"
#       image_tag_mutability = "IMMUTABLE"
#       scan_on_push         = false
#     },
#   }
# }

