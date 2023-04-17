variable "region" {
    description = "The region for deploy network resources"
    type = "string"
}
variable "vpc_main_cidr" {
    default = "10.254.0.0/16"
    description = "The Network Address of VPC"
}
variable "vpc_name" {
    default = "my-vpc"
    description = "The Name of VPC"
    type = "string"
}
variable "public1_cidr" {
    default = "10.254.10.0/24"
    description = "The Network Address of Public Subnet 1"
}
variable "public2_cidr" {
    default = "10.254.20.0/24"
    description = "The Network Address of Public Subnet 2"
}
variable "public3_cidr" {
    default = "10.254.30.0/24"
    description = "The Network Address of Public Subnet 3"
}
variable "private1_cidr" {
    default = "10.254.110.0/24"
    description = "The Network Address of Private Subnet 1"
}
variable "private2_cidr" {
    default = "10.254.120.0/24"
    description = "The Network Address of Private Subnet 2"
}
variable "private3_cidr" {
    default = "10.254.130.0/24"
    description = "The Network Address of Private Subnet 3"
}