# Simple EKS Module

Simple Terraform module to create EKS clusters. The module is quite opinionated to keep things as simple as possible, but it should be sufficient for many use-cases. This module will not create any node groups in the cluster. To do so, use [its companion module](https://github.com/vistaprint/terraform-aws-simple-eks-node-group). An [additional module](https://github.com/vistaprint/terraform-aws-simple-eks-addons) can be used to install several useful applications in the cluster (e.g., metrics server or cluster autoscaler).

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

## References

- [Creating an Amazon EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)
- [Cluster VPC considerations](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)
