include docker.mk

.PHONY: test

PHP_VER ?= 7.4

test:
	cd ./tests && PHP_VER=$(PHP_VER) ./run.sh

wpscan:
	@docker run -it --rm wpscanteam/wpscan --url https://eedama.org/ --enumerate u1-100 --api-token=DtG1ECayC8urb56socjzrSaxggIELZQaywY75kGcbXA
