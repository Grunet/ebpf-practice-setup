login:
	az login
init:
	cd ./infra/ && terraform init
create-plan:
	# "yes y" automatically overwrites whatever key pair was previously there
	yes y | ssh-keygen -t rsa -f ~/.ssh/id_rsa -P ""
	cd ./infra/ && terraform plan -out main.tfplan
create-apply:
	cd ./infra/ && terraform apply main.tfplan
ssh:
	# Overwrite what's in ~/.ssh/known-hosts every time
	ssh-keyscan -H -t rsa $(shell cd ./infra/ && terraform output -raw vm_public_ip_address) > ~/.ssh/known_hosts
	ssh adminuser@$(shell cd ./infra/ && terraform output -raw vm_public_ip_address)
destroy-plan:
	cd ./infra/ && terraform plan -destroy -out main.destroy.tfplan
destroy-apply:
	cd ./infra/ && terraform apply main.destroy.tfplan