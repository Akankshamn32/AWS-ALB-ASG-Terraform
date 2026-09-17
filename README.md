# AWS ALB + Auto Scaling Group using Terraform

## Project Overview

This project provisions a highly available web application infrastructure on AWS using Terraform.

The infrastructure includes:

- Amazon VPC
- Internet Gateway
- Public Subnets across 2 Availability Zones
- Application Load Balancer (ALB)
- ALB Target Group
- ALB Listener
- Launch Template
- EC2 instances
- Auto Scaling Group (ASG)
- Security Groups
- Auto Scaling based on CPU utilization
- Apache Web Server

## Architecture

```text
                    Internet
                       |
                       |
              Application Load Balancer
                       |
                Target Group
                 /     |     \
                /      |      \
             EC2      EC2      EC2
             AZ-1     AZ-1     AZ-2
                \      |      /
                 Auto Scaling
                    Group