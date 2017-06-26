#!/bin/sh

OBJECTS_LIST=/root/OBJECTS-FOR-PREFIX-LIST
bgpq3=/usr/local/bin/bgpq3
vtysh_cmd='/usr/local/bin/vtysh -E -c'
TMP_PREFIX_LIST_FILE=/tmp/quagga-TMP-prefix-list
PREFIX_LIST_FILE=/tmp/quagga-PREFIX-LIST

do_vtysh () # Обновляем Quagga Prefix-List
{
	use_file="$(cat < $PREFIX_LIST_FILE)"
	$vtysh_cmd "$use_file"
	rm $TMP_PREFIX_LIST_FILE
}

if [ -e $OBJECTS_LIST ]
then 

echo "configure terminal" > $TMP_PREFIX_LIST_FILE

while IFS=" " read line; do
if [ "$line" = "${line%#*}" -a "$line" ]; then

	PREFIX_LIST_NAME=`echo "$line" | awk '{ print $1 }' &> /dev/null`
	OBJECTS=`echo "$line" | awk '{ print $2 }' &> /dev/null`
	DESCRIPTION=`echo "$line" | awk '{ print $3 }' &> /dev/null`

	if [ -z "$PREFIX_LIST_NAME" ]
	then
		echo "Необхоимо указать <PREFIX LIST NAME> "
		exit 
	elif [ -z "$OBJECTS" ]
	then
		echo "Необходимо уазать объект по котрому строить <PREFIX LIST>: AS-SET или AS-NUM <OBJECTS>"
		exit
	else
		PREFIX_LIST=`$bgpq3 -Al $PREFIX_LIST_NAME -m 24 $OBJECTS`

	fi

	if [ -z "$DESCRIPTION" ]
	then
		DESCRIPTION=$PREFIX_LIST_NAME
	else
		DESCRIPTION=$DESCRIPTION
	fi

	BAD_OBJECTS=`echo $PREFIX_LIST |/usr/bin/grep "empty" &> /dev/null`

	if [ -n "$BAD_OBJECTS" ]
	then
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo ""
		echo "$PREFIX_LIST_NAME EMPTY!"
		echo ""
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	else
		echo "$PREFIX_LIST" >> $TMP_PREFIX_LIST_FILE
		echo "ip prefix-list $PREFIX_LIST_NAME description $DESCRIPTION" >> $TMP_PREFIX_LIST_FILE
	fi

fi
done < $OBJECTS_LIST

echo "exit"  >> $TMP_PREFIX_LIST_FILE
echo "write" >> $TMP_PREFIX_LIST_FILE

if [ -e $PREFIX_LIST_FILE ]
then
	
	HASH_TMP=`md5 $TMP_PREFIX_LIST_FILE |awk  '{ FS=" = "; print $2}'&> /dev/null`
	HASH_FILE=`md5 $PREFIX_LIST_FILE |awk  '{ FS=" = "; print $2}'&> /dev/null`

	if [ $HASH_TMP != $HASH_FILE ]
	then
		cp "$TMP_PREFIX_LIST_FILE" "$PREFIX_LIST_FILE"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo ""
		echo "!!! MD5 SUMM CHANGE. NOW WE UPDATE QUAGGA PREFIX-LIST"
		echo ""
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		do_vtysh
	else
		rm $TMP_PREFIX_LIST_FILE
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo ""
		echo "OBJECTS in RADB not change! Nothing doing"
		echo ""
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		exit
		
	fi
else
	cp "$TMP_PREFIX_LIST_FILE" "$PREFIX_LIST_FILE"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo ""
	echo "COPY TMP FILE TO ORIGIANL"
	echo ""
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	do_vtysh
fi

else
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo ""
	echo "!!! File $OBJECTS_LIST NOT FOUND !!!"
	echo ""
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	exit
fi
