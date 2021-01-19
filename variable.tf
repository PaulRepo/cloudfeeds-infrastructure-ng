
variable "environment" {
    description = "The supported environments"
    type = "list"

    default = ["test", "staging", "prod"]
}

## List of supported Cloud Feeds regions
variable "dc_region" {
    description = "A map of regions within each environment."
    type = "map"
    
    default = {
        test = ["test"]
        staging = ["ord-us", "ord-uk"]
        prod = ["ord", "dfw", "iad", "lon", "hkg", "syd"]
    }
}

variable "aws_region" {
    description = "A map of the AWS region correlating to the cloud feeds datacenter service."
    type = "map"

    default = {
        test.test = "us-east-2"
        staging.ord-us = "us-east-2"
        staging.ord-uk = "eu-west-2"
        prod.ord = "us-east-2"
        prod.dfw = "us-east-2"
        prod.iad = "us-east-1"
        prod.lon = "eu-west-2"
        prod.hkg = "ap-east-1"
        prod.syd = "ap-southeast-2"
    }
}

variable "desired_capacity" {
    description = "The capacity on a per environment basis."
    type = "map"

    default = {
        test.test = 1
        staging.ord-us = 1
        staging.ord-uk = 1
        prod.ord = 1
        prod.dfw = 1
        prod.iad = 1
        prod.lon = 1
        prod.syd = 1
        prod.hkg = 1
    }
}

variable "endpoint" {
    description = "The legacy vips for each regional service both external and internal"
    type = "map"

    default = {
        test.test.internal = "atom.test.ord1.us.ci.rackspace.net"
        test.test.external = "test.ord.feeds.api.rackspacecloud.com"
        staging.ord-us.internal = "atom.staging.ord1.us.ci.rackspace.net"
        staging.ord-us.external = "staging.ord.feeds.api.rackspacecloud.com"
        staging.ord-uk.internal = "atom.staging.ord1.uk.ci.rackspace.net"
        staging.ord-uk.external = "staging.lon.feeds.api.rackspacecloud.com"
        prod.ord.internal = "atom.prod.ord1.us.ci.rackspace.net"
        prod.ord.external = "ord.feeds.api.rackspacecloud.com"
        prod.dfw.internal = "atom.prod.dfw1.us.ci.rackspace.net"
        prod.dfw.external = "dfw.feeds.api.rackspacecloud.com"
        prod.iad.internal = "atom.prod.iad3.us.ci.rackspace.net"
        prod.iad.external = "iad.feeds.api.rackspacecloud.com"
        prod.lon.internal = "atom.prod.lon3.uk.ci.rackspace.net"
        prod.lon.external = "lon.feeds.api.rackspacecloud.com"
        prod.syd.internal = "atom.prod.syd2.us.ci.rackspace.net"
        prod.syd.external = "syd.feeds.api.rackspacecloud.com"
        prod.hkg.internal = "atom.prod.hkg1.us.ci.rackspace.net"
        prod.hkg.external = "hkg.feeds.api.rackspacecloud.com"
    }
}
