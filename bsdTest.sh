#!/bin/bash

testFile() {
	echo -e "\nTEST "$1".txt"
	./tp1 test-files/$1.txt | ./tp1 > output/$1.txt
	res1=`md5 test-files/$1.txt`
	res2=`md5 output/$1.txt`
	
	echo "md5 de $1: $res2"
	if [ $res1 == $res2 ]; 
	then
		echo -e "OK\n"
	else
		echo -e "ERROR\n"
	fi
}

testWords() {
	echo -e "\nTEST WORDS"
	res1=`cat '/usr/share/dict/words' | md5`
	res2=`./tp1 '/usr/share/dict/words' | ./tp1 | md5`
	
	echo "md5 de words: $res2"
	if [ $res1 == $res2 ]; 
	then
		echo -e "OK\n"
	else
		echo -e "ERROR\n"
	fi
}

echo Compilando...
gcc -o tp1 main.c

testFile empty
testFile basic
testFile empty-lines
testFile large-file
testFile return
testFile status

testWords
