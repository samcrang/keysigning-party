.PHONY: build clean mostlyclean test

PARTY_NAME?=Keysigning Party
PARTY_DATE?=$(shell date "+%Y%m%d %H%M")
PARTY_ORGANIZER?=John Doe <john.doe@example.com>

OUTPUT_DIRECTORY?=build
INPUT_DIRECTORY?=participants

VAGRANT_MACHINE=.vagrant/machines/default/virtualbox/id

define execute
vagrant ssh --command "$(1)"
endef

build: $(OUTPUT_DIRECTORY)/party.gpg $(OUTPUT_DIRECTORY)/participants.txt

$(OUTPUT_DIRECTORY)/party.gpg: $(VAGRANT_MACHINE)
	mkdir -p  $(OUTPUT_DIRECTORY)
	$(call execute,rm -f ~/.gnupg/party.gpg)
	$(call execute,\
		gpg2 --with-colons --list-keys | \
		grep ^pub: | \
		cut -d : -f 5 | \
		xargs pgp-clean --export-subkeys | \
		gpg2 --keyring party.gpg --no-default-keyring --import)
	$(call execute,gpg2 --keyring party.gpg --no-default-keyring --export --armor) > $@

$(OUTPUT_DIRECTORY)/participants.txt: $(VAGRANT_MACHINE)
	mkdir -p $(OUTPUT_DIRECTORY)
	$(call execute,\
		gpg2 --with-colons --fingerprint | \
		grep -A 1 ^pub | \
		grep ^fpr: | \
		cut -d : -f 10 | \
		gpgparticipants --algorithm=SHA256 - - '$(PARTY_DATE)' '$(PARTY_ORGANIZER)' '$(PARTY_NAME)') > $@

$(VAGRANT_MACHINE): Vagrantfile conf/*/*
	vagrant destroy --force
	vagrant up --provision
	$(call execute,gpg2 --import /vagrant/$(INPUT_DIRECTORY)/*)
	$(call execute,gpg2 --refresh-keys)

test: clean
	mkdir -p test/tmp
	OUTPUT_DIRECTORY=test/tmp/build INPUT_DIRECTORY=test/fixtures make
	bats test/

mostlyclean:
	rm -rf build/
	rm -rf test/tmp/build

clean: mostlyclean
	vagrant destroy --force
