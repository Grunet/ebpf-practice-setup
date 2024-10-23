login:
	az login
init:
	cd ./infra/ && terraform init
create-plan:
	cd ./infra/ && terraform plan -out main.tfplan
create-apply:
	cd ./infra/ && terraform apply main.tfplan
destroy-plan:
	cd ./infra/ && terraform plan -destroy -out main.destroy.tfplan
destroy-apply:
	cd ./infra/ && terraform apply main.destroy.tfplan
publicKeygen:
	ssh-keygen