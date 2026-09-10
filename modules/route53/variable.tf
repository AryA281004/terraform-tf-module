variable "zone_id" {
  description = "The ID of the hosted zone in Route 53."
  type        = string

  validation {
    condition     = can(regex("^Z[A-Z0-9]+$", var.zone_id))
    error_message = "hosted_zone_id must be a valid Route 53 hosted zone ID beginning with Z."
  }
}

variable "records" {
  description = "A map of Route 53 records to create."
  type = map(object({
    name           = string
    type           = string
    ttl            = optional(number)
    records        = optional(list(string), [])
    set_identifier = optional(string)
    alias = optional(object({
      dns_name               = string
      zone_id                = string
      evaluate_target_health = bool
    }))
  }))



  default = {}

  validation {
    condition = alltrue([
      for record in values(var.records) :
      contains([
        "A",
        "AAAA",
        "CAA",
        "CNAME",
        "DS",
        "HTTPS",
        "MX",
        "NAPTR",
        "NS",
        "PTR",
        "SOA",
        "SRV",
        "SSHFP",
        "SVCB",
        "TLSA",
        "TXT"
      ], upper(record.type))
    ])
    error_message = "Each record type must be a supported Route 53 record type."
  }

  validation {
    condition = alltrue([
      for record in values(var.records) : record.alias == null ? (
        record.ttl != null && record.ttl > 0 && length(record.records) > 0
        ) : (
        contains(["A", "AAAA"], upper(record.type)) &&
        record.ttl == null &&
        length(record.records) == 0 &&
        trimspace(record.alias.dns_name) != "" &&
        can(regex("^Z[A-Z0-9]+$", record.alias.zone_id))
      )
    ])
    error_message = "Each record must define a positive TTL and at least one value, or a valid A/AAAA alias with no TTL or record values."
  }

}

variable "allow_overwrite" {
  description = "Whether Route 53 records may overwrite existing records managed outside this module."
  type        = bool
  default     = false
}


