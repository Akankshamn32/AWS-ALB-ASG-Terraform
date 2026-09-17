resource "aws_launch_template" "web" {
  name = "${var.project_name}-launch-template"

  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [
    aws_security_group.web.id
  ]

  user_data = base64encode(<<-EOF
    #!/bin/bash

    dnf update -y
    dnf install -y httpd

    systemctl enable httpd
    systemctl start httpd

    TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" \
      -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

    HOSTNAME=$(curl -s \
      -H "X-aws-ec2-metadata-token: $TOKEN" \
      http://169.254.169.254/latest/meta-data/hostname)

    echo "<html>
    <head>
      <title>AWS ALB ASG Project</title>
    </head>
    <body>
      <h1>AWS ALB + Auto Scaling Group</h1>
      <h2>Web Server: $HOSTNAME</h2>
      <p>Apache is running successfully.</p>
    </body>
    </html>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.project_name}-web-server"
      Project = var.project_name
    }
  }

  tags = {
    Name    = "${var.project_name}-launch-template"
    Project = var.project_name
  }
}