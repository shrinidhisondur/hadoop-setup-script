#!/usr/bin/expect
set host [lindex $argv 0];
set home [lindex $argv 1];
set pass [lindex $argv 2];
set user [lindex $argv 3];
spawn ssh $user@$host mkdir -p $home/.ssh
expect {
    -ex "Are you sure you want to continue connecting (yes/no)?" {
	send "yes\r"
	spawn ssh $host
	expect {
        -ex "Last login:" { }
        -ex "assword" {
             send "$pass\r"
             expect "Last"
        }
        }
    }
    -ex "Last login:" {expect eof}
    -ex "assword" { 
        send "$pass\r" 
        expect eof
    }
    
}

spawn ./key.sh $home $host $user
#cat $home/.ssh/id_rsa.pub | ssh root@$host 'cat >> '$home'/.ssh/authorized_keys'

expect {
    -ex "Are you sure you want to continue connecting (yes/no)?" {
        send "yes\r"
        spawn ssh $host
        expect {
        -ex "Last login:" { }
        -ex "assword" {
             send "$pass\r"
             expect "Last"
        }
        }
    }
    -ex "Last login:" {expect eof}
    -ex "assword" {
        send "$pass\r"
        expect eof
    }

}

