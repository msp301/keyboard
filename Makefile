REPO_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

all:
	$(REPO_DIR)/build.sh

clean:
	rm -rf $(REPO_DIR)/build
