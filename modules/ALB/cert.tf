# Create the certificate using a wildcard for all the domains created in dev.kipkulei.space
resource "aws_acm_certificate" "kipkulei_space" {
  domain_name       = "*.dev.kipkulei.space"
  validation_method = "DNS"



  tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}
#calling the hosted zone
data "aws_route53_zone" "kipkulei_space" {
  name         = "dev.kipkulei.space"
  private_zone = false
}
#selecting validation method 
resource "aws_route53_record" "kipkulei_space" {
  for_each = {
    for dvo in aws_acm_certificate.kipkulei_space.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }


  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.kipkulei_space.zone_id
}

# validate the certificate through DNS method
resource "aws_acm_certificate_validation" "kipkulei_space" {
  certificate_arn         = aws_acm_certificate.kipkulei_space.arn
  validation_record_fqdns = [for record in aws_route53_record.kipkulei_space : record.fqdn]
}

# create records for tooling
resource "aws_route53_record" "tooling" {
  zone_id = data.aws_route53_zone.kipkulei_space.zone_id
  name    = "tooling.dev.kipkulei.space"
  type    = "A"


  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}

# create records for wordpress
resource "aws_route53_record" "wordpress" {
  zone_id = data.aws_route53_zone.kipkulei_space.zone_id
  name    = "wordpress.dev.kipkulei.space"
  type    = "A"


  alias {
    name                   = aws_lb.ext-alb.dns_name
    zone_id                = aws_lb.ext-alb.zone_id
    evaluate_target_health = true
  }
}








