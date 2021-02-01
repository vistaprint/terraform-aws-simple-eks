# Simple EKS Module

## Selecting an Instance Type for EKS Clusters

Several factors need to be considered when choosing an instance type for an EKS cluster:

- Number of vCPUs
- Amount of memory
- Networking capacity
- Cost

Another important criteria is the maximum number of pods the cluster can concurrently run. In a cluster using [native VPC networking](https://docs.aws.amazon.com/eks/latest/userguide/pod-networking.html) the maximum number of pods is limited by the [number of network interfaces in an instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI). [Here](https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt) you can find a list of pod count limits per instance type.

[Alernative pod networking solutions](https://docs.aws.amazon.com/eks/latest/userguide/alternate-cni-plugins.html) exist that lift the pod density limitation. This module supports using [Calico CNI](https://docs.projectcalico.org) to allow for a much higher number of pods per node. This is especially useful when many pods are expected to be running on the cluster, but they will be mostly idle.

## References

- [Creating an Amazon EKS cluster](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)
- [Cluster VPC considerations](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)
- [IAM roles for service accounts technical overview](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts-technical-overview.html)
- [Introducing fine-grained IAM roles for service accounts](https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/)
- [Cluster Autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html)
- [Metrics Server](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html)

### Calico

- https://docs.projectcalico.org/getting-started/kubernetes/managed-public-cloud/eks
- https://docs.projectcalico.org/reference/public-cloud/aws#routing-traffic-within-a-single-vpc-subnet
- https://docs.aws.amazon.com/vpc/latest/userguide/VPC_NAT_Instance.html#EIP_Disable_SrcDestCheck
- https://github.com/awsdocs/amazon-eks-user-guide/blob/master/doc_source/calico.md
- https://github.com/awsdocs/amazon-eks-user-guide/blob/master/doc_source/cni-custom-network.md
- https://github.com/awslabs/amazon-eks-ami/blob/master/files/eni-max-pods.txt
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html#AvailableIpPerENI

Launch templates are needed for Calico:
- https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html
- https://aws.amazon.com/blogs/containers/introducing-launch-template-and-custom-ami-support-in-amazon-eks-managed-node-groups/
