.PHONY: build deploy-preview branch-deploy

build:
	hugo --gc

deploy-preview:
	hugo  --gc --buildFuture -b $(DEPLOY_PRIME_URL)

branch-deploy:
	hugo  --gc -b $(DEPLOY_PRIME_URL)
