DEBUG ?= 0
ANSIBLE_VERBOSE = $(if $(filter 1,$(DEBUG)),-vvv,)

.PHONY: all run debug help pihole nginx crawler immich ftp vaultwarden media

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
	@printf "  immich\n"
	@printf "  ftp\n"
	@printf "  vaultwarden\n"
	@printf "  media\n"

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

immich:
	tofu -chdir=./services/immich/terraform init -upgrade
	tofu -chdir=./services/immich/terraform destroy -auto-approve
	tofu -chdir=./services/immich/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/immich/terraform output -raw lxc_ip); \
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
		./services/immich/ansible/immich.yml;

ftp:
	tofu -chdir=./services/ftp/terraform init -upgrade
	tofu -chdir=./services/ftp/terraform destroy -auto-approve
	tofu -chdir=./services/ftp/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/ftp/terraform output -raw lxc_ip); \
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
		./services/ftp/ansible/ftp.yml; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		-e "tailscale_args=--accept-routes --accept-dns=false" \
		./shared/ansible/tailscale.yml

vaultwarden:
	tofu -chdir=./services/vaultwarden/terraform init -upgrade
	tofu -chdir=./services/vaultwarden/terraform destroy -auto-approve
	tofu -chdir=./services/vaultwarden/terraform apply -auto-approve
	LXC_IP=$$(tofu -chdir=./services/vaultwarden/terraform output -raw lxc_ip); \
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
		./services/vaultwarden/ansible/vaultwarden.yml; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		-e "tailscale_args=--accept-routes --accept-dns=false" \
		./shared/ansible/tailscale.yml

media:
	tofu -chdir=./services/media-v2/terraform init -upgrade
	tofu -chdir=./services/media-v2/terraform apply -auto-approve
	VMID=$$(tofu -chdir=./services/media-v2/terraform output -raw vmid); \
	echo "VMID: $$VMID"; \
	VM_IP=$$(tofu -chdir=./services/media-v2/terraform output -raw vm_ip); \
	echo "VM IP: $$VM_IP"; \
	./services/media-v2/scripts/configure-vm.sh "$$VMID"; \
	set -a; \
	. ./.env 2>/dev/null || true; \
	set +a; \
	ssh-keygen -R "$$VM_IP"; \
	ansible localhost $(ANSIBLE_VERBOSE) -m wait_for -a "host=$$VM_IP port=22 delay=2 timeout=300"; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$VM_IP," \
		-u ubuntu \
		--become \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		./services/media-v2/ansible/media.yml


%:
	@:
