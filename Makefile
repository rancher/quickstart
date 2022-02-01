PROVIDERS = rancher-common aws azure do gcp hcloud linode scw

upgrade-targets = $(addprefix upgrade-, $(PROVIDERS))
docs-targets = $(addprefix docs-, $(PROVIDERS))
tfvars-targets = $(addprefix tfvars-, $(PROVIDERS))
fmt-targets = $(addprefix fmt-, $(PROVIDERS))
validate-targets = $(addprefix validate-, $(PROVIDERS))

upgrade: $(upgrade-targets)
$(upgrade-targets): upgrade-%: %
	cd $< && terraform init -upgrade

docs: $(docs-targets)
$(docs-targets): docs-%: %
	cd $< && terraform-docs -c ../.terraform-docs-readme.yml .

tfvars: $(tfvars-targets)
$(tfvars-targets): tfvars-%: %
	cd $< && terraform-docs -c ../.terraform-docs-tfvars.yml .

fmt: $(fmt-targets)
$(fmt-targets): fmt-%: %
	cd $< && terraform fmt

validate: $(validate-targets)
$(validate-targets): validate-%: %
	cd $< && terraform validate

.PHONY: test
test:
	cd test/ && go test -v -timeout 45m

