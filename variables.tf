variable names {
  description = "name of efs volume to create"
  type        = set(string)
}

variable region {
  description = "region to create efs volume in"
  type        = string
}

variable vpc_id {
  description = "vpc to use for accessing the efs volume"
  type        = string
}

variable security_group_ids {
  description = "security group ids to allow permisson to access efs volume"
  type        = set(string)
}

variable subnet_ids {
  description = "subnet ids"
  type        = set(string)
}
