SERVICE ?= pihole

ifneq (,$(filter run debug,$(MAKECMDGOALS)))
SERVICE := $(word 2,$(MAKECMDGOALS))
endif
SERVICE := $(if $(SERVICE),$(SERVICE),pihole)

DEBUG ?= 0
ANSIBLE_VERBOSE = $(if $(filter 1,$(DEBUG)),-vvv,)

.PHONY: all run debug deploy help

all: run

help:
	@printf "Targets:\n"
	@printf "  make run <service>    - destroy/apply service and run ansible (default: pihole)\n"
	@printf "  make debug <service>  - same as run with ansible -vvv\n"
	@printf "  make help             - show this help\n"
	@printf "Examples:\n"
	@printf "  make run pihole\n"
	@printf "  make debug pihole\n"

run: deploy

debug: DEBUG=1
debug: deploy

deploy:
	terraform -chdir=services/$(SERVICE) destroy -auto-approve
	terraform -chdir=services/$(SERVICE) apply -auto-approve
	LXC_IP=$$(terraform -chdir=services/$(SERVICE) output -raw lxc_ip); \
	echo "LXC IP: $$LXC_IP"; \
	ssh-keygen -R "$$LXC_IP"; \
	ansible localhost $(ANSIBLE_VERBOSE) -m wait_for -a "host=$$LXC_IP port=22 delay=2 timeout=300"; \
	ansible-playbook $(ANSIBLE_VERBOSE) \
		-i "$$LXC_IP," \
		-u root \
		-e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
		ansible/pihole.yml

%:
	@:
