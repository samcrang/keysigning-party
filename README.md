Keysigning Party
================

> "ain't no party like a GPG keysigning party"

Given a collection of public keys provided by the expected participants the scripts in this repo will:

- Import public keys into a GPG instance inside a VM.
- Attempt to find updates to keys from public keyservers.
- Generate a single, armored output of the public keys of all participants (Cleaned using `pgp-clean`).
- Generate a participant list using `gpgparticipant`.

It does all this inside a Vagrant box (so you don't need to worry about it trampling over your local GnuPG configuration) and using a [more-secure-than-default GnuPG configuration](https://github.com/ioerror/duraconf/blob/master/configs/gnupg/gpg.conf).

Usage
-----

1. Dump all the public keys in the `participants/` directory.
2. Set some environment variables (`PARTY_ORANIZER`, `PARTY_NAME`, `PARTY_DATE`).
2. Run `make` (ex: `PARTY_ORGANIZER="John Doe <john.doe@example.com>" PARTY_DATE="20160830 1230" PARTY_NAME="My super awesome party" make`).
3. Check output in `build/`.

Testing
-------

Requires [bats](https://github.com/sstephenson/bats). Run tests with `make test`.

Postface
--------

NB: This was originally hacked together in an afternoon. At the time it seemed like a sensible use of GNU Make (take some files, do some stuff with them using CLI utilities, spit something out), however, it quickly grew to something a bit weird(?). It probably makes sense to pull most of what is in the Makefile out to regular shell scripts(?). This should be reasonably straight forward given the rudimentary tests under `test/`.

You can grab what it's currently doing (and convert it to a shell script) with `make -n`.
