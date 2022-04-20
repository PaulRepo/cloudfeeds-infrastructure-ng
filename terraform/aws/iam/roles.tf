#Role for EKS Cluster
resource "aws_iam_role" "cloudfeeds_eks_cluster_role" {
  name                  = "cloudfeeds_eksClusterRole"
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy    = jsonencode({
    Version             = "2012-10-17"
    Statement           = [
      {
        Action          = "sts:AssumeRole"
        Effect          = "Allow"
        Sid             = ""
        Principal       = {
          Service       = "eks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns   = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSServicePolicy", "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
}

#Role for EKS worker nodes
resource "aws_iam_role" "cloudfeeds_eks_node_role" {
  name                  = "cloudfeeds_eksNodeRole"
  assume_role_policy    = jsonencode({
    Version             = "2012-10-17"
    Statement           = [
      {
        Action          = "sts:AssumeRole"
        Effect          = "Allow"
        Sid             = ""
        Principal       = {
          Service       = "ec2.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns   = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
}

#Role for Dynamodb access
resource "aws_iam_role" "cloudfeeds_dynamodb_access_role" {
  name                  = "cloudfeeds_dynamodbAccessRole"
  assume_role_policy    = jsonencode({
    Version             = "2012-10-17"
    Statement           = [
      {
        Action          = "sts:AssumeRole"
        Effect          = "Allow"
        Sid             = ""
        Principal       = {
          Service       = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#Policy for Dynamodb access
resource "aws_iam_policy" "cloudfeeds_dynamodb_access_policy" {
  name                  = "cloudfeeds_dynamodbAccessPolicy"
  path                  = "/"
  description           = "Policy for access on Cloudfeeds dynamodb table"
  policy                = jsonencode({
    Version             = "2012-10-17"
    Statement           = [
      {
        Action          = [
            "dynamodb:List*",
            "dynamodb:DescribeReservedCapacity*",
            "dynamodb:DescribeLimits",
            "dynamodb:DescribeTimeToLive"
        ]
        Effect          = "Allow"
        Sid             = "ListAndDescribe"
        Resource        = "*"
      },
      {
        Action          = [
           "dynamodb:BatchGet*",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTable",
            "dynamodb:Get*",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:BatchWrite*",
            "dynamodb:CreateTable",
            "dynamodb:Delete*",
            "dynamodb:Update*",
            "dynamodb:PutItem"
        ]
        Effect          = "Allow"
        Sid             = "TableSpecific"
        Resource        = [var.table_arn]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudfeeds_dynamodb_access_policy_attachment" {
  role                  = aws_iam_role.cloudfeeds_dynamodb_access_role.name
  policy_arn            = aws_iam_policy.cloudfeeds_dynamodb_access_policy.arn
}

#Role for S3 access
resource "aws_iam_policy" "cloudfeeds_bucket_access_policy" {
  name                  = "cloudfeeds_bucketAccessPolicy"
  path                  = "/"
  description           = "Allow access on Cloudfeeds bucket"

  policy                = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "",
        Effect : "Allow",
        Action : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource : [var.bucket_arn]
      }
    ]
  })
}

resource "aws_iam_role" "cloudfeeds_bucket_access_role" {
  name                  = "cloudfeeds_bucketAccessRole"

  assume_role_policy    = jsonencode({
    Version             = "2012-10-17"
    Statement           = [
      {
        Action          = "sts:AssumeRole"
        Effect          = "Allow"
        Sid             = ""
        Principal       = {
          Service       = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudfeeds_bucket_access_policy_attachment" {
  role                  = aws_iam_role.cloudfeeds_bucket_access_role.name
  policy_arn            = aws_iam_policy.cloudfeeds_bucket_access_policy.arn
}

#Datadog
resource "aws_iam_policy" "cloudfeeds_datadog_integration_policy" {
  name                  = "cloudfeeds_datadogIntegrationPolicy"
  path                  = "/"
  description           = "Allow access on Cloudfeeds resources"

  policy                = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid     : "",
        Effect  : "Allow",
        Action  : [
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "ec2:Describe*",
                "tag:GetResources",
                "tag:GetTagKeys",
                "tag:GetTagValues"
        ],
        Resource : ["*"]
      }
    ]
  })
}

resource "aws_iam_role" "cloudfeeds_datadog_integration_role" {
  name                  = "cloudfeeds_datadogIntegrationRole"

  assume_role_policy    = jsonencode({
    Version             = "2012-10-17"
    Statement           = [
      {
        Action          = "sts:AssumeRole"
        Effect          = "Allow"
        Sid             = ""
        Principal       = {
          AWS           = ["arn:aws:iam::${var.aws_account_id}:root"]
        }
        Condition       = {
          StringEquals  = { "sts:ExternalId" = var.datadog_aws_integration_external_id[var.environment] }
        }
      },  
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudfeeds_datadog_aws_integration_policy_attachment" {
  role                  = aws_iam_role.cloudfeeds_datadog_integration_role.name
  policy_arn            = aws_iam_policy.cloudfeeds_datadog_integration_policy.arn
}

