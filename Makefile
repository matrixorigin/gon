# release will package the distribution packages, sign, and notarize. It
# will then upload the release to GitHub and publish the Homebrew tap.
#
# AFTER THIS YOU MUST MANUALLY DELETE the checksums.txt file since it is
# incomplete and we don't need checksums since our artifacts are signed.
default: build
GON_VERSION=$(shell git rev-parse --short HEAD)
.PHONY: build
build:
	CGO_ENABLED=0 go build -ldflags="-X 'main.version=$(GON_VERSION)'" -o gon ./cmd/gon

release:
	goreleaser --rm-dist
.PHONY: release

clean:
	rm -rf dist/
.PHONY: clean

# Update the TOC in the README.
readme/toc:
	doctoc --notitle README.md
.PHONY: readme/toc

vendor: vendor/create-dmg

vendor/create-dmg:
	rm -rf vendor/create-dmg
	git clone https://github.com/andreyvit/create-dmg vendor/create-dmg
	rm -rf vendor/create-dmg/.git

