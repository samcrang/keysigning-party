#!/usr/bin/env bats

@test "party.gpg should contain all participants" {
  run bash -c "gpg2 --list-packets test/tmp/build/party.gpg | grep \"^:public key packet:\" | wc -l"
  [ "$output" = "       2" ]
}

@test "party.gpg should only contain self-sigs" {
  run bash -c "gpg2 --list-packets test/tmp/build/party.gpg | grep \"^:signature packet:\" | grep -vE \"(1F07315057BC3A55|79BE3E4300411886)\" | wc -l"
  [ "$output" = "       0" ]
}
