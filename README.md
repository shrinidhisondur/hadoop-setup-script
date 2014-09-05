hadoop-setup-script
===================

Scripts to set up Hadoop for Linux. Script includes configuring a kerberos server.

Edit the hadoop.conf file to specify parameters.
If you are someone who just wants to setup a hadoop cluster, set security to simple.

Usage: ./setup.sh [install] [configure] [start] [all] | [stop]

install :Install all libraries and software to setup Hadoop and Kerberos
configure: Set up configuration for kerberos serverm client, set up kerberos db and set up hadoop configuration;
all parameters set from hadoop.conf
start : Start hadoop cluster
stop : Stop hadoop cluster
DO NOT GIVE CONFIGURE WITHOUT ONCE GIVING AN INSTALL
DO NOT GIVE START WITHOUT COMPLETING INSTALL AND CONFIGURE
If you changed configuration file configure has to be reissued";
