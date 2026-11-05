.PHONY: all help pihole nginx telegrambot ladder media bookorbit syncthing qbittorrent jellyfin prowlarr navidrome flaresolverr matrix

all: pihole nginx telegrambot ladder media bookorbit syncthing qbittorrent jellyfin prowlarr navidrome flaresolverr

help:
	@printf "Targets:\n"
	@printf "  make all              - deploy all services\n"
	@printf "  make <service>        - deploy one service\n"
	@printf "  make help             - show this help\n"
	@printf "Existing services:\n"
	@printf "  pihole\n"
	@printf "  nginx\n"
	@printf "  telegrambot\n"
	@printf "  ladder\n"
	@printf "  flaresolverr\n"
	@printf "  media\n"
	@printf "  bookorbit\n"
	@printf "  syncthing\n"
	@printf "  qbittorrent\n"
	@printf "  jellyfin\n"
	@printf "  prowlarr\n"
	@printf "  matrix\n"
	@printf "  navidrome\n"

pihole:
	tofu -chdir=./services/pihole/terraform apply -auto-approve
	ansible-playbook ./services/pihole/ansible/main.yml


nginx:
	tofu -chdir=./services/nginx/terraform apply -auto-approve
	ansible-playbook ./services/nginx/ansible/main.yml

telegrambot:
	tofu -chdir=./services/telegrambot/terraform apply -auto-approve
	ansible-playbook ./services/telegrambot/ansible/main.yml

ladder: flaresolverr
	tofu -chdir=./services/ladder/terraform apply -auto-approve
	ansible-playbook ./services/ladder/ansible/main.yml

media:
	tofu -chdir=./services/media/terraform init -upgrade
	tofu -chdir=./services/media/terraform apply -auto-approve

bookorbit:
	tofu -chdir=./services/bookorbit/terraform apply -auto-approve
	ansible-playbook ./services/bookorbit/ansible/main.yml

syncthing:
	tofu -chdir=./services/syncthing/terraform apply -auto-approve
	ansible-playbook ./services/syncthing/ansible/main.yml

qbittorrent:
	tofu -chdir=./services/qbittorrent/terraform init
	tofu -chdir=./services/qbittorrent/terraform apply -auto-approve
	ansible-playbook ./services/qbittorrent/ansible/main.yml

jellyfin:
	tofu -chdir=./services/jellyfin/terraform init
	tofu -chdir=./services/jellyfin/terraform apply -auto-approve
	ansible-playbook ./services/jellyfin/ansible/main.yml

flaresolverr:
	tofu -chdir=./services/flaresolverr/terraform init
	tofu -chdir=./services/flaresolverr/terraform apply -auto-approve
	ansible-playbook ./services/flaresolverr/ansible/main.yml

prowlarr:
	tofu -chdir=./services/prowlarr/terraform init
	tofu -chdir=./services/prowlarr/terraform apply -auto-approve
	ansible-playbook ./services/prowlarr/ansible/main.yml

matrix:
	tofu -chdir=./services/matrix/terraform init
	tofu -chdir=./services/matrix/terraform apply -auto-approve
	ansible-playbook ./services/matrix/ansible/main.yml

navidrome:
	tofu -chdir=./services/navidrome/terraform init
	tofu -chdir=./services/navidrome/terraform apply -auto-approve
	ansible-playbook ./services/navidrome/ansible/main.yml

%:
	@:
