DEBUG ?= 0
ANSIBLE_VERBOSE = $(if $(filter 1,$(DEBUG)),-vvv,)

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

run: $(word 2,$(MAKECMDGOALS))

debug: DEBUG=1
debug: $(word 2,$(MAKECMDGOALS))

pihole:
	tofu -chdir=./services/pihole/terraform init -upgrade
	tofu -chdir=./services/pihole/terraform destroy -auto-approve
	tofu -chdir=./services/pihole/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/pihole/terraform output -raw lxc_ip); \
	echo "LXC IP: $$LXC_IP"; \
	ssh-keygen -R "$$LXC_IP"; \
	ansible localhost $(ANSIBLE_VERBOSE) -m wait_for -a "host=$$LXC_IP port=22 delay=2 timeout=300"; \
	set -a; \
	. ./.env; \
	set +a; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		./services/pihole/ansible/pihole.yml; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		-e "tailscale_args=--accept-routes --accept-dns=false" \
		./shared/ansible/tailscale.yml


nginx:
	tofu -chdir=./services/nginx/terraform init -upgrade
	tofu -chdir=./services/nginx/terraform destroy -auto-approve
	tofu -chdir=./services/nginx/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/nginx/terraform output -raw lxc_ip); \
	echo "LXC IP: $$LXC_IP"; \
	ssh-keygen -R "$$LXC_IP"; \
	ansible localhost $(ANSIBLE_VERBOSE) -m wait_for -a "host=$$LXC_IP port=22 delay=2 timeout=300"; \
	set -a; \
	. ./.env; \
	set +a; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		./services/nginx/ansible/nginx.yml; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		./shared/ansible/tailscale.yml

crawler:
	@if [ ! -f .env ]; then \
		echo "Error: .env file not found. Create it from .env.example"; \
		exit 1; \
	fi
	tofu -chdir=./services/crawler/terraform init -upgrade
	tofu -chdir=./services/crawler/terraform destroy -auto-approve
	tofu -chdir=./services/crawler/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/crawler/terraform output -raw lxc_ip); \
	echo "LXC IP: $$LXC_IP"; \
	ssh-keygen -R "$$LXC_IP"; \
	ansible localhost $(ANSIBLE_VERBOSE) -m wait_for -a "host=$$LXC_IP port=22 delay=2 timeout=300"; \
	set -a; \
	. ./.env; \
	set +a; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		-e "telegram_bot_token=$$TELEGRAM_BOT_TOKEN" \
		-e "lxc_ssh_user=$$LXC_SSH_USER" \
		-e "go_version=$$GO_VERSION" \
		./services/crawler/ansible/crawler.yml	

ladder:
	tofu -chdir=./services/ladder/terraform init -upgrade
	tofu -chdir=./services/ladder/terraform destroy -auto-approve
	tofu -chdir=./services/ladder/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/ladder/terraform output -raw lxc_ip); \
	echo "LXC IP: $$LXC_IP"; \
	ssh-keygen -R "$$LXC_IP"; \
	ansible localhost $(ANSIBLE_VERBOSE) -m wait_for -a "host=$$LXC_IP port=22 delay=2 timeout=300"; \
	set -a; \
	. ./.env; \
	set +a; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		./services/ladder/ansible/ladder.yml

flaresolverr:
	tofu -chdir=./services/flaresolverr/terraform init -upgrade
	tofu -chdir=./services/flaresolverr/terraform destroy -auto-approve
	tofu -chdir=./services/flaresolverr/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/flaresolverr/terraform output -raw lxc_ip); \
	echo "LXC IP: $$LXC_IP"; \
	ssh-keygen -R "$$LXC_IP"; \
	ansible localhost $(ANSIBLE_VERBOSE) -m wait_for -a "host=$$LXC_IP port=22 delay=2 timeout=300"; \
	set -a; \
	. ./.env; \
	set +a; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		./services/flaresolverr/ansible/flaresolverr.yml

media:
	tofu -chdir=./services/media/terraform init -upgrade
	tofu -chdir=./services/media/terraform apply -auto-approve

bookorbit:
	tofu -chdir=./services/bookorbit/terraform init -upgrade
	tofu -chdir=./services/bookorbit/terraform destroy -auto-approve
	tofu -chdir=./services/bookorbit/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/bookorbit/terraform output -raw lxc_ip); \
	echo "LXC IP: $$LXC_IP"; \
	ssh-keygen -R "$$LXC_IP"; \
	ansible localhost $(ANSIBLE_VERBOSE) -m wait_for -a "host=$$LXC_IP port=22 delay=2 timeout=300"; \
	set -a; \
	. ./.env; \
	set +a; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		./services/bookorbit/ansible/bookorbit.yml

%:
	@:
