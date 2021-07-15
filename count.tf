
# DH分析者用 saアカウント
locals {
	sa-dh-dupf-anl = [
		for num in range(01, 11) : format("%s%02d", "sa-dh-dupf-anl", num) 
	]
}


# range使う
# https://www.terraform.io/docs/language/functions/range.html

output "sequence_num" {
   value = local.sa-dh-dupf-anl
#   value = [ for num in range(01, 11) : "sa-dh-dupf-anl${num}" ]
# value = [ for num in range(01, 11) : format("%s%02d", "sa-dh-dupf-anl", num) ]
}
