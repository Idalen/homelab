SERVICES := media nameserver reverseproxy telegrambot

.PHONY: all $(SERVICES)

all: $(SERVICES)

$(SERVICES):
	terraform -chdir=services/$@ destroy -auto-approve
	terraform -chdir=services/$@ apply -auto-approve
