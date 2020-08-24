.PHONY: test
test:
	cd test/ && go test -v -timeout 45m

.PHONY: fmt
fmt:
	terraform fmt -recursive