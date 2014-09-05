#!/usr/bin/expect
set realm [lindex $argv 0];
set timeout 100000
spawn /usr/local/sbin/kdb5_util destroy
sleep 1

expect {
     "(type 'yes' to confirm)?" {
        send "yes\r"
     }
     
     eof {}
}

sleep 2
