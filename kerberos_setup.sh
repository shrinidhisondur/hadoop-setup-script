#!/usr/bin/expect
set realm [lindex $argv 0];
set timeout 100000

spawn /usr/local/sbin/kdb5_util create -r $realm -s
sleep 2
expect "Enter KDC database master"
sleep 2
send "commvault\r"
sleep 2
expect "Re-enter KDC database master"
sleep 2
send "commvault\r"

expect { 
	-ex "File exists while creating" {}
    -ex eof {}
}
