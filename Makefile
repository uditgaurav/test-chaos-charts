# Makefile for building Chaos charts
# Reference Guide - https://www.gnu.org/software/make/manual/make.html

.PHONY: deps
deps:  pip_deps godeps
pip_deps:
	@echo "-----Install dependencies-----"
	sudo apt-get update
	sudo apt-get install python3
	sudo apt-get install python3-pip -y
	pip3 install packaging

godeps:
	@echo ""
	@go get -u -v golang.org/x/lint/golint
	@go get -u -v golang.org/x/tools/scripts/goimports

.PHONY: versionmaker
versionmaker:
	@echo "-----version maker-----"
	bash ./scripts/version/version_maker.sh

.PHONY: combineExpCR
combineExpCR:
	@echo "--------Combining Experiments CR-------"
	go run combine-all-crs.go -v scripts

.PHONY: push
push:
	@echo "---------git push to master-------"
	bash ./scripts/version/push.sh
