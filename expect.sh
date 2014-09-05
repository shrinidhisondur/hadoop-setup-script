pwd=`pwd`

rm -f $pwd/expect.log

sleep 1
printf  "\n[SETUPINFO] Installing expect. Config and make Logs can be seen at $pwd/expect.log \n"
sleep 2
if [ ! -z "$1" ]
then
	cd $1
fi

wget http://prdownloads.sourceforge.net/expect/expect5.45.tar.gz
tar xvf expect5.45.tar.gz > $pwd/expect.log
rm -f expect5.45.tar.gz
cd expect5.45
./configure > $pwd/expect.log
make install > $pwd/expect.log
cd $pwd
