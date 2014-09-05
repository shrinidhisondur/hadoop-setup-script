filename=$1
name=$2
value=$3

echo "<property>" >> "$filename"
echo "	<name>$name</name>" >> "$filename"
echo "	<value>$value</value>" >> "$filename"
echo "</property>">> "$filename"
