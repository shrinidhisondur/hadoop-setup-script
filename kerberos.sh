pwd=`pwd`
rm -f $pwd/kerberos.log

sleep 1
printf "\n[SETUPINFO] Installing Kerberos. Build logs can be seen at $pwd/kerberos.log\n"
sleep 2
if [ ! -z "$1" ]
then
	cd $1
fi

rm -rf krb5-1.11.5*
wget http://web.mit.edu/kerberos/dist/krb5/1.11/krb5-1.11.5-signed.tar
tar xvf krb5-1.11.5-signed.tar  > $pwd/kerberos.log
tar xvf krb5-1.11.5.tar.gz > $pwd/kerberos.log
cd krb5-1.11.5/src
./configure > $pwd/kerberos.log
make -s > $pwd/kerberos.log
make install -s > $pwd/kerberos.log
cd ../../
rm -f krb5-1.11.5-signed.tar
rm -f krb5-1.11.5.tar.gz

cd $pwd
