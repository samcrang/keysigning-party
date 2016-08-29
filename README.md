Keysigning Party
================

Takes a collection of public keys then generates and exports a keyring of cleaned (using `pgp-clean`) public keys and an attendees list (using `gpgparticipants`). It does all this inside a Vagrant machine so you don't have to worry about it messing around with your local keyrings.

Usage
-----

1. Dump all the public keys in the `attendees` directory.
2. Set some environment variables (`PARTY_ORANIZER`, `PARTY_NAME`, `PARTY_DATE`).
2. Run `make`. (ex: `PARTY_ORGANIZER="John Doe <john.doe@example.com>" PARTY_DATE="20160830 1230" PARTY_NAME="My super awesome party" make`)
3. Check output in `build/`
