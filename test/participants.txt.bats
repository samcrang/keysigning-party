#!/usr/bin/env bats

@test "participants.txt should contain all participants" {
  run bash -c "grep pub test/tmp/build/participants.txt | wc -l"
  [ "$output" = "       2" ]
}
