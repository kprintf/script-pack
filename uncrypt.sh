#!/bin/bash
( echo "echo "`gpg --decrypt "$1" | tr -d "\r" | tr "\n" "\r" | sed "s/=\r=/=/g" | tr "\r" "\n" | base64 | tr -d "\n" `" | base64 -d |"
for i in `echo абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ | grep -o "."`; 
do 
echo 'sed "s/'`echo $i | tr -d "\n" | od -An -t x1 | tr " abcdef" "=ABCDEF"`"/$i/g\" |"
done
echo "tr '' ''" # NOP bash-style 
) | bash
