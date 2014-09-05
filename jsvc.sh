pwd=`pwd`
rm -f $pwd/jsvc.log
sleep 1
printf "\n[SETUPINFO] Installing JSVC. Config and build logs can be seen at $pwd/jsvc.log"
sleep 2

if [ ! -z "$1" ]
then
cd $1
fi

rm -rf commons-daemon-1.0.15*
wget http://apache.arvixe.com//commons/daemon/source/commons-daemon-1.0.15-src.tar.gz
tar xvf commons-daemon-1.0.15-src.tar.gz > $pwd/jsvc.log
cd commons-daemon-1.0.15-src/src/native/unix
./configure > $pwd/jsvc.log
make > $pwd/jsvc.log
rm -f $HADOOP_HOME/bin/jsvc
cp jsvc $HADOOP_HOME/bin/
cd ../../../../
rm -f commons-daemon-1.0.15-src.tar.gz
export JSVC_HOME=$HADOOP_HOME/bin

cd $pwd
