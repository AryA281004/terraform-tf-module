# outputs.tf

output "record_fqdns" {
  description = "FQDN of each Route 53 record created"
  value       = { for k, v in aws_route53_record.this : k => v.fqdn }
}

output "record_names" {
  description = "Name of each Route 53 record created"
  value       = { for k, v in aws_route53_record.this : k => v.name }
}

output "record_ids" {
  description = "Record set ID (zone_id_name_type_[set_identifier])"
  value       = { for k, v in aws_route53_record.this : k => v.id }
}