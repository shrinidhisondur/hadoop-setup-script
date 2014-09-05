sleep 1
printf  "\n[SETUPINFO] Generating Keygen Pairs for password free sshs to datanodes \n"
sleep 2

rm -rf $HOME/.ssh/
ssh-keygen -t dsa -P '' -f $HOME/.ssh/id_dsa
ssh-keygen -t rsa -P '' -f $HOME/.ssh/id_rsa

source hadoop.conf
name=`hostname -I`
re="(.+) {1,}.+"
if [[ "$name" =~ $re ]]
then
   hostip="${BASH_REMATCH[1]}";
fi
sleep 1
printf  "\n[SETUPINFO] Putting HostIP = $hostip against $hostname in /etc/hosts file \n"
sleep 2

hostname=`hostname`
exists=`grep $hostname /etc/hosts`
echo "exists = $exists"
if [ -z "$exists" ]
then
    echo "$hostip       $hostname" >> /etc/hosts
fi

sleep 1
printf  "\n[SETUPINFO] Making a bunch of IPs like localhost password free ssh \n"
sleep 2
expect sshKey.sh $hostip $HOME $pass $username
expect sshKey.sh 0.0.0.0 $HOME $pass $username
expect sshKey.sh localhost $HOME $pass $username
expect sshKey.sh $hostname $HOME $pass $username

sleep 1
while read line
    do
    sleep 1
    printf  "\n[SETUPINFO] Making $dn password free ssh from namenode"
    sleep 1
    dn=`echo $line | cut -f1 -d " "`
    user=`echo $line | cut -f2 -d " "`
    pass=`echo $line | cut -f3 -d " "`
    ip=`echo $line | cut -f4 -d " "`

    exists=`grep $dn /etc/hosts`
    echo "exists = $exists"
    sleep 1
    printf "\n[SETUPINFO] Making datanode: $dn reachable. Adding IP host binding to /etc/hosts file"
    sleep 2
    if [ -z "$exists" ]
    then
        echo "$ip       $dn" >> /etc/hosts
    else
	sed -i '/'$dn'/d' /etc/hosts
	echo "$ip       $dn" >> /etc/hosts
    fi
    expect sshKey.sh $dn $HOME $pass $user
done < "datanodes.list"

