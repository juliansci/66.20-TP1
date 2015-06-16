testFile() {
	echo -e "\nTEST "$1".txt"
	./tp1 test-files/$1.txt | ./tp1 > output/$1.txt
	res1=`cat test-files/$1.txt | md5`
	res2=`cat output/$1.txt | md5`
	if [ $res1 == $res2 ]; 
	then
		echo -e "OK\n"
	else
		echo -e "ERROR\n"
	fi
}

echo Compilando...
make

testFile basic
testFile empty
testFile empty-lines
testFile large-file
testFile null
testFile random
testFile return
testFile status

