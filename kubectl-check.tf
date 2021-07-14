resource "null_resource" "check_aws_credentials_are_available" {
  triggers = {
    always_run = uuid()
  }

  provisioner "local-exec" {
    command = <<-EOT
      sh -c '
        aws sts get-caller-identity
        if [ $? -ne 0 ]; then
          echo "There was some issue trying to execute the AWS CLI."
          echo "This might mean no valid credentials are configured."
          exit 1
        fi'
      EOT
  }
}

resource "null_resource" "update_kubeconfig_with_cluster_info" {
  triggers = {
    always_run = uuid()
  }

  provisioner "local-exec" {
    command = <<-EOT
      aws eks \
        --profile ${var.profile} \
        --region ${var.region} \
        update-kubeconfig \
        --name ${aws_eks_cluster.cluster.name}
    EOT

    interpreter = ["bash", "-c"]
  }

  depends_on = [
    null_resource.check_aws_credentials_are_available,
    aws_eks_cluster.cluster
  ]
}
