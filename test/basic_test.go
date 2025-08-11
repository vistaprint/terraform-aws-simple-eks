package test

import (
	"os"
	"slices"
	"testing"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/eks"
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

	skipDestroy := os.Getenv("SKIP_DESTROY") == "true"

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../examples/basic",
		Vars: map[string]any{
			"aws_profile": awsProfile,
			"aws_region":  awsRegion,
			"vpc_name":    vpcName,
		},
		NoColor: true,
	})

	if !skipDestroy {
		defer terraform.Destroy(t, terraformOptions)
	}

	terraform.InitAndApply(t, terraformOptions)

	checkClusterExists(t, "simple-eks-integration-test", awsRegion)

	assert.Regexp(t,
		`^https:\/\/oidc\.eks\..+\.amazonaws\.com\/id\/.+$`,
		terraform.Output(t, terraformOptions, "oidc_identity_provider_issuer"),
	)
}

func checkClusterExists(t *testing.T, clusterName string, region string) {
	config, err := config.LoadDefaultConfig(t.Context(), config.WithRegion(region))
	require.NoError(t, err)

	client := eks.NewFromConfig(config)

	output, err := client.ListClusters(t.Context(), &eks.ListClustersInput{})
	require.NoError(t, err)

	if slices.Contains(output.Clusters, clusterName) {
		return
	}

	t.Fatalf("EKS cluster %s not found in region %s", clusterName, region)
}
