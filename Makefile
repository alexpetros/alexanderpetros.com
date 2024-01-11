PROJECT_ROOT=www

.PHONY: dev
dev:
	serve $(PROJECT_ROOT)

.PHONY: validate
validate:
	vnu --skip-non-html --also-check-css html

.PHONY: rss
rss:
	./scripts/generate-rss.sh > html/rss.xml
