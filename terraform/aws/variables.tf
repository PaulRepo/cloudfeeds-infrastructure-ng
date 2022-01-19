variable "aws_access_key" {
default = "ASIA2R5DFDN5KPH4TJQA"
}

variable "aws_secret_key" {
default = "t4kAV9qgZkbArA2BEuAmNDJDQXgf7jPt9Xjl81Km"
}

variable "aws_session_token" {
default = "IQoJb3JpZ2luX2VjENX//////////wEaCXVzLWVhc3QtMSJHMEUCIQCvTXNh8hpGnReHaZuDxzYDMruOX6tfloUxNEYbBXihcQIgU7u8upVUtQeszjgLILbVxgzp+oPTe81B33ZAYG/2h9Aq5gII7v//////////ARACGgw3MjU2NTQ3NzI2MDIiDN+wJfy6FY0lhrSR2Sq6AsfNrQW6x0dN/jU2b0z2TB/iqypJ8Nn2dh+dCd58HyhWcxKAbhnZZyN9ylJN5xQNUYeSahff29rD84IaTRYZozEB1Sq3xA8Iq3VxJr+5hIh9sHJA0eFsPFgKV13sVcFEKG7qIVqsDpAly+3QLyB5VDILe7caOsTuhKuITqIXAYVJM4xagjuFCYfg3YQv18XttjNriv3wLskMzxjkKtUN2lhQT7AH8jPDZo0dVyB6rYtC4Dpa/Q6hGkQdOBhOT7jt7g9KDjZE9I5vJQHIEltlTd9oS0Ec5pI7lSAoe8A4RyRnRQsZ7d8U68vQ4O0XQKgTIAoS1G4uAgCG8vNUno/sqwEeTyVy7xr9DMYwqKPr/ZA3kRGtzd+H5tGF2zCs/BDwea8jcCQoDWVypj7iU30JAfoek+nG+vYTK8caML2OoI8GOt0BRMfW+LdXF4dQMBXAgeiMiEaen8VqJSxfqAoaf465D7kTi+dV/9LkGivPQyHxHy7XFTC61nr2Er/30XUw3J3X/tjJt08QqvUmGJfZfB8tBRdT4rhQV0YPEKqV9/yXNYIH6Jh3pojndgYjhFcJF0j8Ni2hApscqs1EsY7x222nhHlcUhvfZxISbfSGgAaXZYd7Op9GCZPeO71Ty4g5XgL+RwJvZlVX+xyzhjZUYwFuYqogzphqTotXFlY8bsjpCAj1kCssfMZpdVY22qfvDZyb88kZsrkEZ2GrACv8vas="
}

variable "region" {
    default = "ap-south-1"
}

## List of supported Cloud Feeds regions
variable "environment" {
    description = "The supported environments"
    type = map(string)
    default = {
        TEST = "test"
        STAGE = "staging"
        PROD = "production"
    }
}

variable "active_environment" {
    description = "The active environment"
    type = string 
    default = "TEST"
}

variable "dc_region" {
    description = "A map of regions within each environment."
    type = map(map(string))
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

variable "aws_region" {
    description = "A map of the AWS region correlating to the cloud feeds datacenter service."
    type = map(string)

    default = {
        "test" = "us-east-2"
        "staging.ord-us" = "us-east-2"
        "staging.ord-uk" = "eu-west-2"
        "prod.ord" = "us-east-2"
        "prod.dfw" = "us-east-2"
        "prod.iad" = "us-east-1"
        "prod.lon" = "eu-west-2"
        "prod.hkg" = "ap-east-1"
        "prod.syd" = "ap-southeast-2"
    }
}

variable "desired_capacity" {
    description = "The capacity on a per environment basis."
    type = map(string)

    default = {
        "test.test" = 1
        "staging.ord-us" = 1
        "staging.ord-uk" = 1
        "prod.ord" = 1
        "prod.dfw" = 1
        "prod.iad" = 1
        "prod.lon" = 1
        "prod.syd" = 1
        "prod.hkg" = 1
    }
}

variable "endpoint" {
    description = "The legacy vips for each regional service both external and internal"
    type = map(string)

    default = {
        "test.test.internal" = "atom.test.ord1.us.ci.rackspace.net"
        "test.test.external" = "test.ord.feeds.api.rackspacecloud.com"
        "staging.ord-us.internal" = "atom.staging.ord1.us.ci.rackspace.net"
        "staging.ord-us.external" = "staging.ord.feeds.api.rackspacecloud.com"
        "staging.ord-uk.internal" = "atom.staging.ord1.uk.ci.rackspace.net"
        "staging.ord-uk.external" = "staging.lon.feeds.api.rackspacecloud.com"
        "prod.ord.internal" = "atom.prod.ord1.us.ci.rackspace.net"
        "prod.ord.external" = "ord.feeds.api.rackspacecloud.com"
        "prod.dfw.internal" = "atom.prod.dfw1.us.ci.rackspace.net"
        "prod.dfw.external" = "dfw.feeds.api.rackspacecloud.com"
        "prod.iad.internal" = "atom.prod.iad3.us.ci.rackspace.net"
        "prod.iad.external" = "iad.feeds.api.rackspacecloud.com"
        "prod.lon.internal" = "atom.prod.lon3.uk.ci.rackspace.net"
        "prod.lon.external" = "lon.feeds.api.rackspacecloud.com"
        "prod.syd.internal" = "atom.prod.syd2.us.ci.rackspace.net"
        "prod.syd.external" = "syd.feeds.api.rackspacecloud.com"
        "prod.hkg.internal" = "atom.prod.hkg1.us.ci.rackspace.net"
        "prod.hkg.external" = "hkg.feeds.api.rackspacecloud.com"
    }
}
