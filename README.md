- ここの検証
https://zenn.dev/wim/articles/terraform_loop


```
resource "aws_route53_record" "this" {
  for_each = {
    for d in var.domains : d.domain_name => {
      name   = d.resource_record_name
      record = d.resource_record_value
      type   = d.resource_record_type
    }
  }

#これに関していえば、
#keyが d.domain_name value が =>{} の中 (オブジェクト)


  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 100
  type            = each.value.type
  zone_id         = var.zone_id
}
```

- やはり公式が俊逸
- https://www.terraform.io/docs/language/meta-arguments/for_each.html

- ウッチーのカオス
https://gist.github.dena.jp/mitsuki-hiroe/b27156d53df2cc7c15a0976f85231cae

ー 複数の型を入れ子にできない
https://kazuhira-r.hatenablog.com/entry/2020/10/21/131440

- ECRつくる
https://yhidetoshi.hatenablog.com/entry/2020/02/19/215431

- init
- terraform init


- terrafrom apply で確認
