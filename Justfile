PROJECT_ROOT := "www"
LB_ROOT := "www/letterboxd"

dev:
	serve {{PROJECT_ROOT}}

validate:
	vnu --skip-non-html --also-check-css html

lb:
	cat {{LB_ROOT}}/reviews.csv | gawk --csv -f {{LB_ROOT}}/lb.awk > {{LB_ROOT}}/index.html

deploy:
	git push
	ssh mrg 'cd /var/www/alexanderpetros.com && git pull'
