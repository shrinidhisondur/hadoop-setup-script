home=$1
host=$2
user=$3

cat $home/.ssh/id_rsa.pub | ssh $user@$host 'cat >> '$home'/.ssh/authorized_keys'
