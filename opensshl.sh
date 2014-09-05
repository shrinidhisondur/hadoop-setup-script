pwd=`pwd`
rm -f $pwd/opensslssh.log

sleep 1
printf  "\n[SETUPINFO] Installing OpenSSL and OpenSSH. Config and make Logs can be seen at $pwd/opensslssh.log\n"
sleep 2

cd $path

wget http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-6.6p1.tar.gz
echo "\n[SETUPINFO] Downloading OpenSSL"
wget http://www.openssl.org/source/openssl-1.0.1h.tar.gz
tar xvf openssh-6.6p1.tar.gz > $pwd/opensslssh.log
tar xvf openssl-1.0.1h.tar.gz > $pwd/opensslssh.log
rm -f openssl-1.0.1h.tar.gz
rm -f openssh-6.6p1.tar.gz

printf "\n[SETUPINFO] Installing OpenSSL\n"
cd openssl-1.0.1h/
./config > $pwd/opensslssh.log
make install > $pwd/opensslssh.log
cd ..

printf "\n[SETUPINFO] Installing OpenSSH\n"
cd openssh-6.6p1/
./configure > $pwd/opensslssh.log
make install > $pwd/opensslssh.log
cd ..

cd $pwd
