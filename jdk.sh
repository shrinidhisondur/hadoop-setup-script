pwd=`pwd`

rm -f $pwd/jdk.log
sleep 1
printf  "\n[SETUPINFO] Installing OpenSSL and OpenSSH. Config and make Logs can be seen at $pwd/jdk.log\n"
sleep 1

if [ ! -z "$1" ]
then
	cd $1
fi

rm -rf jdk1.7.0_60*
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u60-b19/jdk-7u60-linux-x64.tar.gz
tar xvf jdk-7u60-linux-x64.tar* > $pwd/jdk.log
rm -f jdk-7u60-linux-x64.tar*
cd jdk1.7.0_60
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

echo "[INFO] Setting JAVA_HOME to $SCRIPTPATH"
export JAVA_HOME=$SCRIPTPATH

cd $pwd
