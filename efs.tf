# create key from key management system
resource "aws_kms_key" "dev-kms" {
  description = "KMS key "
  policy      = <<EOF
  {
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${var.account_no}:user/babu" },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}


# create key alias
resource "aws_kms_alias" "alias" {
  name          = "alias/kms"
  target_key_id = aws_kms_key.dev-kms.key_id
}


# create Elastic file system
resource "aws_efs_file_system" "dev-efs" {
  encrypted  = true
  kms_key_id = aws_kms_key.dev-kms.arn


  tags = merge(
    var.tags,
    {
      Name = var.name
    },
  )
}


# set first mount target for the EFS 
resource "aws_efs_mount_target" "subnet-1" {
  file_system_id  = aws_efs_file_system.dev-efs.id
  subnet_id       = aws_subnet.private_subnet[2].id
  security_groups = [aws_security_group.datalayer-sg.id]
}


# set second mount target for the EFS 
resource "aws_efs_mount_target" "subnet-2" {
  file_system_id  = aws_efs_file_system.dev-efs.id
  subnet_id       = aws_subnet.private_subnet[3].id
  security_groups = [aws_security_group.datalayer-sg.id]
}


# create access point for wordpress
resource "aws_efs_access_point" "wordpress" {
  file_system_id = aws_efs_file_system.dev-efs.id


  posix_user {
    gid = 0
    uid = 0
  }


  root_directory {
    path = "/wordpress"


    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }


  }


}


# create access point for tooling
resource "aws_efs_access_point" "tooling" {
  file_system_id = aws_efs_file_system.dev-efs.id
  posix_user {
    gid = 0
    uid = 0
  }


  root_directory {


    path = "/tooling"


    creation_info {
      owner_gid   = 0
      owner_uid   = 0
      permissions = 0755
    }


  }
}


# This section will create the subnet group for the RDS  instance using the private subnet
resource "aws_db_subnet_group" "dev-rds" {
  name       = "dev-rds"
  subnet_ids = [aws_subnet.private_subnet[2].id, aws_subnet.private_subnet[1].id]

  tags = merge(
    var.tags,
    {
      Name = var.name
    },
  )
}


# create the RDS instance with the subnets group
resource "aws_db_instance" "dev-rds" {

  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username               = var.master-username
  password               = var.master-password
  parameter_group_name   = "default.mysql5.7"
  db_subnet_group_name   = aws_db_subnet_group.dev-rds.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.datalayer-sg.id]
  multi_az               = "true"
}
