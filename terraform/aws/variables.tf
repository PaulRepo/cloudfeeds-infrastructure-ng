variable "project_name" {
  description = "Name of the project, used in prefix of each resource"
  default     = "cloudfeeds"
}

variable "aws_access_key" {
  description = "Access key to AWS console"
}

variable "aws_secret_key" {
  description = "Secret key to AWS console"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}


## List of supported Cloud Feeds regions
variable "environments" {
  description = "The supported environments"
  type        = map(string)
  default = {
    TEST  = "test"
    STAGE = "staging"
    PROD  = "production"
  }
}

variable "active_environment" {
  description = "The active environment"
  type        = string
}

variable "dc_region" {
  description = "A map of regions within each environment."
  type        = map(map(string))
  default = {
    TEST = {
      TEST = "test"
    }
    STAGE = {
      ORD-US = "ord-us"
      ORD-UK = "ord-uk"
    }
    PROD = {
      ORD = "ord"
      DFW = "dfw"
      IAD = "iad"
      LON = "lon"
      HKG = "hkg"
      SYD = "syd"
    }
  }
}

variable "dc_aws_region" {
  description = "A map of the AWS region correlating to the cloud feeds datacenter service."
  type        = map(string)

  default = {
    "test"           = "us-east-2"
    "staging.ord-us" = "us-east-2"
    "staging.ord-uk" = "eu-west-2"
    "prod.ord"       = "us-east-2"
    "prod.dfw"       = "us-east-2"
    "prod.iad"       = "us-east-1"
    "prod.lon"       = "eu-west-2"
    "prod.hkg"       = "ap-east-1"
    "prod.syd"       = "ap-southeast-2"
  }
}

variable "desired_capacity" {
  description = "The capacity on a per environment basis."
  type        = map(string)

  default = {
    "test.test"      = 1
    "staging.ord-us" = 1
    "staging.ord-uk" = 1
    "prod.ord"       = 1
    "prod.dfw"       = 1
    "prod.iad"       = 1
    "prod.lon"       = 1
    "prod.syd"       = 1
    "prod.hkg"       = 1
  }
}

variable "endpoint" {
  description = "The legacy vips for each regional service both external and internal"
  type        = map(string)

  default = {
    "test.test.internal"      = "atom.test.ord1.us.ci.rackspace.net"
    "test.test.external"      = "test.ord.feeds.api.rackspacecloud.com"
    "staging.ord-us.internal" = "atom.staging.ord1.us.ci.rackspace.net"
    "staging.ord-us.external" = "staging.ord.feeds.api.rackspacecloud.com"
    "staging.ord-uk.internal" = "atom.staging.ord1.uk.ci.rackspace.net"
    "staging.ord-uk.external" = "staging.lon.feeds.api.rackspacecloud.com"
    "prod.ord.internal"       = "atom.prod.ord1.us.ci.rackspace.net"
    "prod.ord.external"       = "ord.feeds.api.rackspacecloud.com"
    "prod.dfw.internal"       = "atom.prod.dfw1.us.ci.rackspace.net"
    "prod.dfw.external"       = "dfw.feeds.api.rackspacecloud.com"
    "prod.iad.internal"       = "atom.prod.iad3.us.ci.rackspace.net"
    "prod.iad.external"       = "iad.feeds.api.rackspacecloud.com"
    "prod.lon.internal"       = "atom.prod.lon3.uk.ci.rackspace.net"
    "prod.lon.external"       = "lon.feeds.api.rackspacecloud.com"
    "prod.syd.internal"       = "atom.prod.syd2.us.ci.rackspace.net"
    "prod.syd.external"       = "syd.feeds.api.rackspacecloud.com"
    "prod.hkg.internal"       = "atom.prod.hkg1.us.ci.rackspace.net"
    "prod.hkg.external"       = "hkg.feeds.api.rackspacecloud.com"
  }
}

variable "identity_env" {
  description = "A map of the Identity environments correlating to the cloud feeds environment."
  type        = map(string)

  default = {
    "test"       = "staging.identity-internal.api.rackspacecloud.com"
    "staging"    = "staging.identity-internal.api.rackspacecloud.com"
    "production" = "identity.api.rackspacecloud.com"
  }
}


################################################################################
# Variables required by VPC
################################################################################

variable "private_subnets_cidr" {
  description = "CIDR for private subnets"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets_cidr" {
  description = "CIDR for private subnets"
  default     = ["10.0.4.0/24"]
}

variable "vpc_cidr" {
  type        = string
  description = "The IP range to use for the VPC"
  default     = "10.0.0.0/16"
}

variable "az" {
  description = "All the avialibility zone."
  default     = ["us-east-1a", "us-east-1b"]
}

################################################################################
# Variables required by EKS
################################################################################

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.22"
}

variable "mixed_min_size" {
  type        = number
  default     = 1
  description = "Minimum size required."
}

variable "mixed_max_size" {
  type        = number
  default     = 2
  description = "Maximum size required."
}

variable "mixed_desired_size" {
  type        = number
  default     = 1
  description = "Size required."
}