.PHONY: build clean mostlyclean

PARTY_NAME?=Keysigning Party
PARTY_DATE?=$(shell date "+%Y%m%d %H%M")
PARTY_ORGANIZER?=John Doe <john.doe@example.com>
VAGRANT_MACHINE=.vagrant/machines/default/virtualbox/id

define execute
vagrant ssh --command "$(1)"
endef

build: build/party.gpg build/participants.txt

build/party.gpg: $(VAGRANT_MACHINE)
	mkdir -p build
	$(call execute,rm -f ~/.gnupg/party.gpg)
	$(call execute,\
		gpg2 --with-colons --list-keys | \
		grep ^pub: | \
		cut -d : -f 5 | \
		xargs pgp-clean --export-subkeys | \
		gpg2 --keyring party.gpg --no-default-keyring --import)
	$(call execute,gpg2 --keyring party.gpg --no-default-keyring --export --armor) > $@

build/participants.txt: $(VAGRANT_MACHINE)
	mkdir -p build
	$(call execute,\
		gpg2 --with-colons --fingerprint | \
		grep -B 1 ^pub | \
		grep ^fpr: | \
		cut -d : -f 10 | \
		gpgparticipants --algorithm=SHA256 - - '$(PARTY_DATE)' '$(PARTY_ORGANIZER)' '$(PARTY_NAME)') > $@

$(VAGRANT_MACHINE): Vagrantfile conf/*/*
	vagrant destroy --force
	vagrant up --provision
	$(call execute,gpg2 --import /vagrant/participants/*)
	$(call execute,gpg2 --refresh-keys)

mostlyclean:
	rm -rf build/

clean: mostlyclean
	vagrant destroy --force
