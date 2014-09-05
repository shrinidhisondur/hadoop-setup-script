pwd=`pwd`

rm -f $pwd/hadoop.log
sleep 1
printf  "\n[SETUPINFO] Installing Hadoop2.4. Config and make Logs can be seen at $pwd/hadoop.log \n"
sleep 1

if [ ! -z "$1" ]
then
	cd $1
fi

rm -rf hadoop-2.4*
wget http://mirror.cc.columbia.edu/pub/software/apache/hadoop/common/hadoop-2.4.0/hadoop-2.4.0.tar.gz
tar xvf hadoop-2.4.0.tar.gz > $pwd/hadoop.log
cd hadoop-2.4.0
SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
cd ../
rm -f hadoop-2.4.0.tar.gz

export HADOOP_HOME=$SCRIPTPATH
cd $pwd
