#!/usr/bin/expect
set hadoop_home [lindex $argv 0];

spawn $hadoop_home/bin/hadoop namenode -format
expect {
	-ex "Re-format filesystem in Storage Directory" {
		send "Y\r"
		expect {
			-ex "SHUTDOWN_MSG: Shutting down NameNode" { }
		}
    }

	-ex "SHUTDOWN_MSG: Shutting down NameNode" {
    
	}
}
