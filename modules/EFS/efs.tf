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
  subnet_id       = var.efs-subnet-1
  security_groups = var.efs-sg
}


# set second mount target for the EFS 
resource "aws_efs_mount_target" "subnet-2" {
  file_system_id  = aws_efs_file_system.dev-efs.id
  subnet_id       = var.efs-subnet-2
  security_groups = var.efs-sg
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

