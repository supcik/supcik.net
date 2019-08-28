.PHONY: build deploy-preview branch-deploy

build:
	hugo --gc
	html-minifier --input-dir public --output-dir public --collapse-whitespace --file-ext html

deploy-preview:
	hugo  --gc --buildFuture -b $(DEPLOY_PRIME_URL)

branch-deploy:
	hugo  --gc -b $(DEPLOY_PRIME_URL)
