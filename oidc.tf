locals {
  oidc_server = split("/", aws_eks_cluster.cluster.identity.0.oidc.0.issuer)[2]
}

data "external" "thumbprint" {
  count = var.create_identity_provider ? 1 : 0

  program = ["sh", "-c", <<-EOT
    thumbprint=$(echo -n \
        | openssl s_client \
            -servername ${local.oidc_server} \
            -showcerts \
            -connect ${local.oidc_server}:443 2> /dev/null \
        | awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/' \
        | tac \
        | sed '/-----BEGIN CERTIFICATE-----/q' \
        | tac \
        | openssl x509 -fingerprint -noout \
        | cut -d'=' -f 2 \
        | tr -d ':' \
        | tr '[:upper:]' '[:lower:]'); echo "{\"thumbprint\": \"$thumbprint\"}"
  EOT
  ]
}

resource "aws_iam_openid_connect_provider" "provider" {
  count = var.create_identity_provider ? 1 : 0

  url = aws_eks_cluster.cluster.identity.0.oidc.0.issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.external.thumbprint.0.result["thumbprint"]
  ]
}
