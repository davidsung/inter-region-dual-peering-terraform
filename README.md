# Interconnecting Cross Region VPCs using both VPC Peering and Transit Gateway Peering on different subnets
![Architecture](asset/architecture.png)

## Preparation
Rename `terraform.tfvars.template` to `terraform.tfvars`
```shell
mv terraform.tfvars.template terraform.tfvars
```
Edit `terraform.tfvars` and configure the `instance_type` and `network_interface_count` accordingly

## Stack Provisioning
```shell
terraform init
terraform plan
terraform apply
```

## Outputs
1. Get the Outputs Value
```shell
terraform output
```

## Teardown
```shell
terraform destroy
```
