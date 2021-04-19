package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestTerraformBasicExample(t *testing.T) {
	t.Parallel()

	awsProfile := os.Getenv("AWS_PROFILE")
	require.NotEmpty(t, awsProfile)

	awsRegion := os.Getenv("AWS_DEFAULT_REGION")
	require.NotEmpty(t, awsRegion)

	vpcName := os.Getenv("SIMPLE_EKS_TEST_VPC_NAME")
	require.NotEmpty(t, vpcName)

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		Vars: map[string]interface{}{
			"aws_profile": awsProfile,
			"aws_region":  awsRegion,
			"vpc_name":    vpcName,
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	assert.Regexp(t,
		`^arn:aws:iam::.+:role\/simple-eks-integration-test-eks-worker-role$`,
		terraform.Output(t, terraformOptions, "worker_role_arn"),
	)

	assert.NotEmpty(t, terraform.Output(t, terraformOptions, "private_subnet_ids"))

	assert.Regexp(t,
		`^https:\/\/oidc\.eks\..+\.amazonaws\.com\/id\/.+$`,
		terraform.Output(t, terraformOptions, "oidc_identity_provider_issuer"),
	)
}
