region = "eu-central-1"
cluster_version = "1.26"
min_size = "3"
max_size = "5"
instance_count = "3"
instance_type = "t3.medium"
hosted_zone = "example.com"
vpc_id = "vpc-005c394e7270f1da3"
public_subnets = [
    "subnet-079a4e2d5f0ad34e2",
    "subnet-01d1389971b742cf8",
    "subnet-06975b916497e5803",
]
private_subnets = [
    "subnet-079a4e2d5f0ad34e2",
    "subnet-01d1389971b742cf8",
    "subnet-06975b916497e5803"
]
Admin_username = "Example_Admin"
teams = [
  "team1",
  "team2",
]
