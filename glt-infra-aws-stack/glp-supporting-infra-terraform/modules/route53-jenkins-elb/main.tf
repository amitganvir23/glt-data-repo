/* Register ELB with route53 dns service
examples
- internal_zone_id: Z2WUFSTRXBZ83 (private hosted zone)
- internal_dns_name: consul.stage-internal.com
- elb_internal_name: module.elb.dns_name
- elb_zone_id: module.elb.zone_id
*/

#For consul internal route53 entry

resource "aws_route53_record" "jenkins-elb" {
  # Create this resource if needed
  zone_id = "${var.external_zone_id}"
  name    = "${var.jenkins_dns_name}.${var.external_route53_domain}"
  type    = "A"

  alias {
    name                   = "${var.elb_internal_name}"
    zone_id                = "${var.elb_internal_zone_id}"
    evaluate_target_health = true
  }
}
