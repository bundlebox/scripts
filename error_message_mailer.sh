#!/bin/bash

APPDIR=$1
LOGFILE=$(echo "$APPDIR.errors.txt" | sed 's/\.\///g' )
ERRORLOG="./temp/loggy$RANDOM.txt"
MAIL="bdambros@claresco.com"

if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0` [somestuff]"
  exit 0
fi

mkdir -p ./temp

for FILE in $(find $APPDIR); do
  head -n 2 $FILE | tail -n 1 >> $ERRORLOG
done

#Generate list of errors with count of occurance
sort $ERRORLOG | uniq -c | sort -n -r >> $LOGFILE
echo -e "\n\n" >> $LOGFILE

echo "Generating list of errors with counts"
echo "--------------LOGFILE IS: ---------------"
cat $LOGFILE


#Generate list without counts to search for errors in dir
sort $ERRORLOG | uniq -c | sort -n -r | sed 's/[0-9]//g' | sed -e 's/^[ \t]*//'| sed 's/\s*$//g' | perl -ne 'print quotemeta($_)' | sed 's/\\*$//g' > pattern.txt


echo "Generating list without counts"
echo "---------------pattern.txt ----------------"
cat pattern.txt


#Find one file each error in the list
while read -r line; do grep -rl "$line" $1 | head -1 >> stackfile.txt ; done < pattern.txt

echo "----------Displaying one file per error---------"
cat stackfile.txt



#Adding stacktraces to log for e-mail
while read -r line; do echo -e $line "\n" >> $LOGFILE; cat $line >> $LOGFILE; echo -e "\nEnd of Stacktrace\n" >> $LOGFILE; done < stackfile.txt


echo "----------These are the stacktraces for our errors--------"
cat $LOGFILE;


#Finally, send mail
echo "Mailing to: " $MAIL
echo -e "Subject:Error Log Project \n\n `cat $LOGFILE`\n" | sendmail $MAIL
echo "DONE!!!"


#Delete temp files last
rm -rf ./temp
rm $LOGFILE
rm pattern.txt
rm stackfile.txt
echo "Temporary files deleted"