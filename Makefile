deploy: install-terraform run-deploy

install-terraform:
	bash bin/install-terraform.sh

run-deploy:
	bash bin/deploy.sh

destroy:
	bash bin/destroy.sh