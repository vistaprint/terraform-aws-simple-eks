# Simple EKS Module

> [!NOTE]
> This module only supports the creation of EKS clusters using [Auto Mode](https://docs.aws.amazon.com/eks/latest/userguide/automode.html).

Simple Terraform module to create EKS clusters. The module is quite opinionated to keep things as simple as possible, but it should be sufficient for many use-cases. This module will only create the system node pool. To create additional node pools, use [its companion module](https://github.com/vistaprint/terraform-aws-simple-eks-node-pool).

## Development

### Testing

We use [Terratest](https://github.com/gruntwork-io/terratest) to run integration tests.

Before running the tests the following environment variables must be set:

- AWS_PROFILE: the AWS profile to use for the test
- AWS_DEFAULT_REGION: region where the test cluster will be created
- SIMPLE_EKS_TEST_VPC_NAME: VPC to be used by the test cluster

Then, go into `test` folder and run:

```shell
go test -v -timeout 30m
```
