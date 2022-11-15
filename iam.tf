
resource "aws_iam_role" "ssm_fleet_ec2" {
  name = "nginx-ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })


}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "registrion_profile"
  role = aws_iam_role.ssm_fleet_ec2.name
}

resource "aws_iam_policy" "policy" {
  name        = "registration_policy"
  description = "Access  policy of ec2 to ssm fleet"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
         "ssm:UpdateInstanceInformation",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }   
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  role       = aws_iam_role.ssm_fleet_ec2.name
  policy_arn = aws_iam_policy.policy.arn
}