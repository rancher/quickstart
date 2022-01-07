PROVIDERS = aws azure do gcp hcloud linode scw
upgrade-targets = $(addprefix upgrade-, $(PROVIDERS))

upgrade: $(upgrade-targets)

$(upgrade-targets): upgrade-%: %
	cd $< && terraform init -upgrade

.PHONY: test
test:
	cd test/ && go test -v -timeout 45m

.PHONY: fmt
fmt:
	terraform fmt -recursive
