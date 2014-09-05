#Sets up passwordless loging for localhost, hostname name and 0.0.0.0
usage="\nUsage: ./setup.sh [install] [configure] [all]
install :Install all libraries and software to setup Hadoop and Kerberos
configure: Set up configuration for kerberos serverm client, set up kerberos db and set up hadoop configuration; all parameters set from hadoop.conf
start : Start hadoop datanode\n
DO NOT GIVE CONFIGURE WITHOUT ONCE GIVING AN INSTALL
If you changed configuration file config has to be reissued\n\n";

if [ -z "$1" ]
then
printf "$usage"
exit 1
fi

if [ ! $1 == "install" ] && [ ! $1 == "configure" ]
then
printf "$usage"
exit 1
fi

install="false";
configure="false";
start="false";

if [ $1 == "all" ]
then
    install="true";
    configure="true";
    start="true";
fi

if [ $1 == "install" ]
then
    install="true"
fi

if [ $1 == "configure" ]
then 
    configure="true"
fi

if [ ! -z "$2" ] && [ $2 == "configure" ]
then
    configure="true"
fi

if [ $install == "true" ]
then
    source hadoop.conf
    mkdir $path
    source tcl.sh $path
    source expect.sh $path
fi

source passphraseless.sh

if [ $install == "true" ]
then
    source opensshl.sh $path
    source jdk.sh $path
    source hadoop.sh $path
    source jsvc.sh $path
    source kerberos.sh $path
    exists=`grep JAVA_HOME ~/.bashrc`
    sleep 1
    printf "\n[SETUPINFO] Setting JAVA_HOME to $JAVA_HOME in ~/bashrc\n"
    sleep 2
    if [ -z "$exists" ]
    then
        echo "export JAVA_HOME=$JAVA_HOME" >> ~/.bashrc
    else
        sed -i '/JAVA_HOME/c\export JAVA_HOME='$JAVA_HOME ~/.bashrc
    fi

    sleep 1
    printf "\n[SETUPINFO] Setting HADOOP_HOME to $HADOOP_HOME in ~/bashrc\n"
    sleep 2

    exists=`grep HADOOP_HOME ~/.bashrc`
    if [ -z "$exists" ]
    then
        echo "export HADOOP_HOME=$HADOOP_HOME" >> ~/.bashrc
    else
        sed -i '/HADOOP_HOME/c\export HADOOP_HOME='$HADOOP_HOME ~/.bashrc
    fi

    sleep 1
    printf "\n[SETUPINFO] Setting JSVC_HOME to $JSVC_HOME in ~/bashrc\n"
    sleep 2

    exists=`grep JSVC_HOME ~/.bashrc`
    if [ -z "$exists" ]
    then
    echo "export JSVC_HOME=$HADOOP_HOME/bin" >> ~/.bashrc
    else
    sed -i '/JSVC_HOME/c\export JSVC_HOME='$HADOOP_HOME/bin ~/.bashrc
    fi
fi

source ~/.bashrc
if [ -z "$JAVA_HOME" ]; then
    sleep 1
    echo "\n[ERROR] Set JAVA_HOME to jdk or issue ./setup.sh install and java is installed and JAVA_HOME is set"
    sleep 2
    exit 1
fi
if [ -z "$HADOOP_HOME" ]; then
    sleep 1
    echo "\n[ERROR] Need to set HADOOP_HOME or issue ./setup.sh install and hadoop2.4 is installed and HADOOP_HOME is set"
    sleep 2
    exit 1
fi
if [ -z "$JSVC_HOME" ]; then
    sleep 1
    echo "\n[ERROR] Need to set JSVC_HOME or issue ./setup.sh install and JSVC is installed and JSVC_HOME is set"
    sleep 2
    exit 1
fi

export PATH=$JAVA_HOME/bin:$HADOOP_HOME:bin:$JSVC_HOME:$PATH

exists=`grep lib/native $HADOOP_HOME/etc/hadoop/hadoop-env.sh`
if [ -z "$exists" ]
then
    echo "export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
    echo "export HADOOP_OPTS=\"\${HADOOP_OPTS} -Djava.library.path=$HADOOP_HOME/lib\"" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
fi


if [ $configure == "true" ]
then
    sleep 1
    printf "\n[SETUPINFO] Starting Configuration\n"
    sleep 2
    sleep 1
    printf "\n[SETUPINFO] Stopping firewall\n"
    sleep 2
    /etc/init.d/iptables stop
    source hadoop.conf

    if [ -z "$hostname" ] 
    then
    sleep 1
    printf "\n[ERROR] Couldn't acquire hostname. Set hostname='Whateveryourhostnameis' in hadoop.conf \n"
    sleep 2
    exit 1
    fi

    if [ -z "$security" ] 
    then
        sleep 1
        printf "\n[ERROR] security is not set in hadoop.conf. Set security=simple for non secure hadoop cluster or security=kerberos for secure cluster\n"
        sleep 2
        exit 1
    fi

    if [ ! "$security" == simple ] && [ ! "$security" == "kerberos" ] 
    then
        sleep 1
        printf "\n[ERROR] security parameter in hadoo.conf set to invalid value\n"
        sleep 2
        exit 1
    fi

    if [ -z "$replication" ] 
    then
        printf "\n[ERROR] replication is not set in hadoop.conf. Set it to 1 if no replication needed\n"
        exit 1
    fi

    if [ -z "$realm" ] && [ "$security" == "kerberos"]
    then
        sleep 1
        printf "\n[ERROR] realm is not set in hadoop.conf. Set it to HDFS if not sure\n"
        sleep 2
        exit 1
    fi

    if [ -z "$permissions" ]
    then
        sleep 1
        printf "\n[ERROR] permissions is not set in hadoop.conf. Set it to false if not sure. Lookup Hadoop documentation to know its meaning\n"
        sleep 2
        exit 1
    fi

    if [ ! "$permissions" == "false" ] && [ ! "$permissions" == "true" ]
    then
        sleep 1
        printf "\n[ERROR] permissions parameter in hadoop.conf set to invalid value\n"
        sleep 2
        exit 1
    fi

    if [ -z "$keytab" ]
    then
        sleep 1
        printf "\n[ERROR] keytab is  not set in hadoop.conf. Set it to /etc/common.keytab if not sure\n"
        sleep 2
        exit 1
    fi

    if [ -z "$tokenvalidity" ] && [ "$security" == "kerberos"]
    then
        tokenvalidity=3600
    fi

    sleep 1
    printf "[SETUPINFO] Setting up core-site.xml for hadoop \n"
    sleep 2

    rm -rf core-site.xml
    filename="core-site.xml"
    cat license >> $filename
    echo "<configuration>" >> $filename
    ./putProperty.sh $filename fs.default.name hdfs://$namenode:9000
    ./putProperty.sh $filename hadoop.tmp.dir $hdfstmp
    ./putProperty.sh $filename hadoop.security.authentication $security
    if [ "$security" == "kerberos" ]
    then
        ./putProperty.sh $filename hadoop.security.authorization "true"
   	./putProperty.sh $filename hadoop.http.authentication.token.validity $tokenvalidity
    else
        ./putProperty.sh $filename hadoop.security.authorization "false"
    fi
    
    echo "</configuration>" >> $filename

    sleep 1
    printf "[SETUPINFO] Setting up hdfs-site.xml for hadoop \n"
    sleep 2

    filename="hdfs-site.xml"
    rm -rf hdfs-site.xml
    cat license >> $filename
    echo "<configuration>" >> $filename
    ./putProperty.sh $filename dfs.replication $replication
    ./putProperty.sh $filename dfs.webhdfs.enabled "true"
    ./putProperty.sh $filename dfs.permissions $permissions
    #kserver="$hostname"

    if [ "$security" == "kerberos" ]
    then
        ./putProperty.sh $filename dfs.block.access.token.enable true
        ./putProperty.sh $filename dfs.datanode.data.dir.perm 777
        ./putProperty.sh $filename dfs.datanode.address $hostname:1010
        ./putProperty.sh $filename dfs.datanode.http.address $hostname:1011
    	
 	./putProperty.sh $filename dfs.namenode.kerberos.principal "nn/_HOST@$realm"
        ./putProperty.sh $filename dfs.namenode.kerberos.internal.spnego.principal "HTTP/_HOST@$realm"
    
        ./putProperty.sh $filename dfs.datanode.kerberos.principal "dn/_HOST@$realm"
        ./putProperty.sh $filename dfs.datanode.keytab.file "$keytab"
        ./putProperty.sh $filename dfs.datanode.kerberos.internal.spnego.principal "HTTP/_HOST@$realm"

        ./putProperty.sh $filename dfs.web.authentication.kerberos.principal "HTTP/_HOST@$realm"
        ./putProperty.sh $filename dfs.web.authentication.kerberos.keytab "$keytab"
        
	exists=`grep "HADOOP_SECURE_DN_USR" $HADOOP_HOME/etc/hadoop/hadoop-env.sh`
        if [ -z "$exists" ]
        then
            sed -i '/HADOOP_SECURE_DN_USER/c\ ' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
            echo "export HADOOP_SECURE_DN_USER=$username" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh
        fi
        
        rm -f krb5.conf
        cp krb5default.conf krb5.conf
        
        sed -i '/default_realm = DEFAULT-REALM/c\ default_realm = '$realm krb5.conf
        sed -i '/DEFAULT-REALM = {/c\ '$realm' = {' krb5.conf
        sed -i '/kdc = kdc/c\ kdc = '$kserver krb5.conf
        sed -i '/admin_server = admin_server/c\ admin_server = '$kserver krb5.conf
        sed -i '/default-domain = default-domain/c\ default-domain = '$kserver krb5.conf
        sed -i '/dotrealm = REALM/c\ .'$kserver' = '$realm krb5.conf
        sed -i '/realm = REALM/c\ '$kserver' = '$realm krb5.conf

        sed -i '/DEFAULT-REALM = {/c\ '$realm' = {' kdc.conf

        yes | cp krb5.conf /etc/
        yes | cp /etc/datanode.keytab $keytab

        expect kerberos_destroy.sh $realm
 	rm -rf /usr/local/var/krb5kdc/principal*   	
        kinit -k -t $keytab $username/$hostname@$realm
    
    #/usr/local/sbin/kadmin.local -q "addprinc -randkey $username/$hostname@$realm"
    #/usr/local/sbin/kadmin.local -q "addprinc -randkey HTTP/$hostname@$realm"
    #/usr/local/sbin/kadmin.local -q "addprinc -randkey dn/$hostname@$realm"
    #/usr/local/sbin/kadmin.local -q "xst -norandkey -k $keytab $username/$hostname HTTP/$hostname dn/$hostname"
    else
	sed -i '/HADOOP_SECURE_DN_USER/c\ ' $HADOOP_HOME/etc/hadoop/hadoop-env.sh
    fi

    echo "</configuration>" >> $filename

    `rm -f $HADOOP_HOME/etc/hadoop/core-site.xml`
    `cp core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml`
    `rm -f $HADOOP_HOME/etc/hadoop/hdfs-site.xml`
    `cp hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml`
    
    printf "\n[SETUPINFO] Configuration Done!\n"
fi
