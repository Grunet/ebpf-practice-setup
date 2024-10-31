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
create:
	make create-plan && make create-apply
ssh:
	# Overwrite what's in ~/.ssh/known-hosts every time
	IP_ADDRESS=$$(cd ./infra/ && terraform output -raw vm_public_ip_address); \
	ssh-keyscan -H -t rsa $$IP_ADDRESS > ~/.ssh/known_hosts; \
	ssh adminuser@$$IP_ADDRESS; 
ping:
	# Overwrite what's in ~/.ssh/known-hosts every time
	IP_ADDRESS=$$(cd ./infra/ && terraform output -raw vm_public_ip_address); \
	ssh-keyscan -H -t rsa $$IP_ADDRESS > ~/.ssh/known_hosts; \
	# "adminuser" here is duplicated in "main.tf" \
	ansible -i $$IP_ADDRESS, all -m ping -u adminuser;
configure:
	# Overwrite what's in ~/.ssh/known-hosts every time
	IP_ADDRESS=$$(cd ./infra/ && terraform output -raw vm_public_ip_address); \
	ssh-keyscan -H -t rsa $$IP_ADDRESS > ~/.ssh/known_hosts; \
	cd ./configuration-management/; \
	# Overwrite what's in inventory.ini every time \
	echo "[myhosts]\n$$IP_ADDRESS" > inventory.ini; \
	# "adminuser" here is duplicated in "main.tf" \
	ansible-playbook playbook.yaml -vv -i inventory.ini -u adminuser;
destroy-plan:
	cd ./infra/ && terraform plan -destroy -out main.destroy.tfplan
destroy-apply:
	cd ./infra/ && terraform apply main.destroy.tfplan
destroy:
	make destroy-plan && make destroy-apply