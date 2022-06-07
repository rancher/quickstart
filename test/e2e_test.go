package test

import (
	"crypto/tls"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/k8s"
	"github.com/gruntwork-io/terratest/modules/terraform"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/util/rand"
)

func TestE2E_RancherAws(t *testing.T) {
	runTerraformAndVerify(t, "../rancher/aws")
}

func TestE2E_RancherAzure(t *testing.T) {
	runTerraformAndVerify(t, "../rancher/azure")
}

func TestE2E_RancherDo(t *testing.T) {
	runTerraformAndVerify(t, "../rancher/do")
}

func TestE2E_RancherGcp(t *testing.T) {
	runTerraformAndVerify(t, "../rancher/gcp")
}

func TestE2E_RancherHcloud(t *testing.T) {
	runTerraformAndVerify(t, "../rancher/hcloud")
}

func TestE2E_RancherLinode(t *testing.T) {
	runTerraformAndVerify(t, "../rancher/linode")
}

func TestE2E_RancherScw(t *testing.T) {
	runTerraformAndVerify(t, "../rancher/scw")
}

func TestE2E_NeuVectorAws(t *testing.T) {
	runTerraformAndVerify(t, "../neuvector/aws")
}

func runTerraformAndVerify(t *testing.T, terraformDir string) {
	t.Parallel()

	prefix := "qs-" + rand.String(5) + "-test"

	terraformOptions := &terraform.Options{
		TerraformDir: terraformDir,
		Vars: map[string]interface{}{
			"prefix": prefix,
		},
	}

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	rancherServerURL := terraform.Output(t, terraformOptions, "rancher_server_url")

	http_helper.HttpGetWithRetryWithCustomValidation(
		t,
		rancherServerURL,
		&tls.Config{
			InsecureSkipVerify: true,
		},
		30,
		5*time.Second,
		func(statusCode int, body string) bool {
			if statusCode != 200 {
				return false
			}
			return true
		})

	k8sOptions := k8s.NewKubectlOptions("", fmt.Sprintf("%s/kube_config_server.yaml", terraformDir), "cattle-system")

	k8s.WaitUntilAllNodesReady(t, k8sOptions, 10, 5*time.Second)

	rancherPods := k8s.ListPods(t, k8sOptions, metav1.ListOptions{})

	assert.Greater(t, len(rancherPods), 0)

	for _, rancherPod := range rancherPods {
		k8s.WaitUntilPodAvailable(t, k8sOptions, rancherPod.Name, 10, 5*time.Second)
	}
}
