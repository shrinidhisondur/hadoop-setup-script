pwd=`pwd`
printf  "[SETUPINFO] Installing TCL. Config and make Logs can be seen at $pwd/tcl.log in tcl.log \n"
if [ ! -z "$1" ]
then
cd $path
fi

wget http://downloads.sourceforge.net/tcl/tcl8.6.1-src.tar.gz
tar xvf tcl8.6.1-src.tar.gz > $pwd/tcl.log
rm -f tcl8.6.1-src.tar.gz
cd tcl8.6.1/unix 
./configure > $pwd/tcl.log
make install > $pwd/tcl.log
cd $pwd
