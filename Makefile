PROJECT_ROOT=www
LB_ROOT=www/letterboxd

.PHONY: dev
dev:
	serve $(PROJECT_ROOT)

.PHONY: validate
validate:
	vnu --skip-non-html --also-check-css html

.PHONY: lb
lb:
	cat $(LB_ROOT)/reviews.csv | gawk --csv -f $(LB_ROOT)/lb.awk > $(LB_ROOT)/index.html
