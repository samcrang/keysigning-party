Keysigning Party
================

Given a collection of public keys provided by the expected participants the scripts in this repo will:

- Import public keys into a GPG instance inside a VM.
- Attempt to find updates to keys from public keyservers.
- Generate a single, armored output of the public keys of all participants (Cleaned using `pgp-clean`)
- Generate a participant list using `gpgparticipant`.

It does all this inside a Vagrant box (so you don't need to worry about it trampling over your local GnuPG configuration) and using a [more-secure-than-default GnuPG configuration](https://github.com/ioerror/duraconf/blob/master/configs/gnupg/gpg.conf).

Usage
-----

1. Dump all the public keys in the `participants/` directory.
2. Set some environment variables (`PARTY_ORANIZER`, `PARTY_NAME`, `PARTY_DATE`).
2. Run `make`. (ex: `PARTY_ORGANIZER="John Doe <john.doe@example.com>" PARTY_DATE="20160830 1230" PARTY_NAME="My super awesome party" make`)
3. Check output in `build/`
