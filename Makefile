.PHONY: clean build

PARTY_NAME?=Keysigning Party
PARTY_DATE?=$(shell date "+%Y%m%d %H%M")
PARTY_ORGANIZER?=John Doe <john.doe@example.com>

define execute
vagrant ssh -c "$(1)"
endef

build: build/party.gpg build/attendees.txt

build/party.gpg: .vagrant/machines/default/virtualbox/id
	mkdir -p build
	$(call execute,rm -f ~/.gnupg/party.gpg)
	$(call execute,\
		gpg2 --with-colons --list-keys | \
		grep ^pub: | \
		cut -d : -f 5 | \
		xargs pgp-clean --export-subkeys | \
		gpg2 --keyring party.gpg --no-default-keyring --import)
	$(call execute,gpg2 --keyring party.gpg --no-default-keyring --export --armor) > $@

build/attendees.txt: .vagrant/machines/default/virtualbox/id
	mkdir -p build
	$(call execute,\
		gpg2 --with-colons --fingerprint | \
		grep -B 1 ^pub | \
		grep ^fpr: | \
		cut -d : -f 10 | \
		gpgparticipants - - '$(PARTY_DATE)' '$(PARTY_ORGANIZER)' '$(PARTY_NAME)') > $@

.vagrant/machines/default/virtualbox/id: Vagrantfile conf/*/*
	vagrant destroy --force
	vagrant up --provision
	$(call execute,gpg2 --import /vagrant/attendees/*)
	$(call execute,gpg2 --refresh-keys)

clean:
	vagrant destroy --force
	rm -rf build/
