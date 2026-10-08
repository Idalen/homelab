.PHONY: all run debug help pihole nginx crawler ladder flaresolverr media bookorbit

all: pihole

help:
	@printf "Targets:\n"
	@printf "  make run <service>    - deploy service\n"
	@printf "  make debug <service>  - deploy service with verbose outputs\n" 
	@printf "  make help             - show this help\n"
	@printf "Existing services:\n"
	@printf "  pihole\n"
	@printf "  nginx\n"
	@printf "  crawler\n"
	@printf "  ladder\n"
	@printf "  flaresolverr\n"
	@printf "  media\n"
	@printf "  bookorbit\n"

pihole:
	tofu -chdir=./services/pihole/terraform apply -auto-approve
	ansible-playbook ./services/pihole/ansible/main.yml


nginx:
	tofu -chdir=./services/nginx/terraform apply -auto-approve
	ansible-playbook ./services/nginx/ansible/main.yml

crawler:
	tofu -chdir=./services/crawler/terraform apply -auto-approve
	ansible-playbook ./services/crawler/ansible/main.yml

ladder:	
	tofu -chdir=./services/ladder/terraform apply -auto-approve
	ansible-playbook ./services/ladder/ansible/main.yml

media:
	tofu -chdir=./services/media/terraform init -upgrade
	tofu -chdir=./services/media/terraform apply -auto-approve

bookorbit:
	tofu -chdir=./services/bookorbit/terraform apply -auto-approve
	ansible-playbook ./services/bookorbit/ansible/main.yml

%:
	@:
