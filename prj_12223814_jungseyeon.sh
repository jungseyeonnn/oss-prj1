#!/bin/bash
echo "--------------------------"
echo "User Name: Jung seyeon"
echo "Student Number: 12223814"
echo "[  MENU  ]"
echo "1. Get the data of the movie identified by a specific'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item’"
echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
echo "4. Delete the ‘IMDb URL’ from ‘u.item'"
echo "5. Get the data about users from 'u.user’"
echo "6. Modify the format of 'release date' in 'u.item’"
echo "7. Get the data of movies rated by a specific 'user id'from 'u.data'"
echo "8. Get the average 'rating' of movies rated by users with'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"

while true
do
	read -p "Enter your choice [ 1-9 ] " choice
	case $choice in
	1)	
		echo
		read -p "Please enter 'movie id'(1~1682):" movie_id
		echo
		awk -v mi="$movie_id" -F "|" '$1 == mi {print $0}' u.item
		echo
		;;
	2)
		echo
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n):" answer
		echo
		if [ $answer = "y" ]
		then 
			awk -F "|" '$7 == 1 {print $1 " " $2}' u.item | sort -n | head -10
		     	echo
		fi
		;;
	3)
		echo
		read -p "Please enter 'movie id' (1~1682):" movie_id
		echo
		average=$(cat u.data| awk -v mi=$movie_id '$2==mi {sum+=$3; n++} END {if (n > 0) printf "%.5f", sum/n}')
    		echo "average rating of $movie_id: $average"
		echo
		;;

	4)
		echo
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n):" answer
		echo
		if [ $answer = 'y' ] 	
		then
			sed 's/http[^|]*//' u.item | head -10
			echo
		fi
		;;
	5)
		echo
		read -p "Do you want to get the data about users from 'u.user'? (y/n):" answer
		echo	
		if [ $answer = 'y' ]
		then
			cat u.user | awk -F '|' '{print "user " $1 " is " $2 " years old " $3 " " $4 }'| sed 's/M/male/' |  sed 's/F/female/' | head -10
			echo
		fi
		;;
	6)
		echo
		read -p "Do you want to Modify the format of 'release data' in 'u.item'? (y/n):" answer
		echo
		if [ $answer = 'y' ]
		then
			cat u.item |sed 's/\([0-9]\{2\}\)-\([A-Z][a-z]\{2\}\)-\([0-9]\{4\}\)/\3\2\1/g' |sed 's/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/;s/Jun/06/; s/Jul/07/;s/Aug/08/;s/Sep/09/;s/Oct/10/;s/Nov/11/; s/Dec/12/;'| tail
			echo
		fi
		;;
	7)
		echo
		read -p "Please enter the 'user id'(1~943) :" user_id
		movie_ids=$(cat u.data | awk -v user_id="$user_id" '$1 == user_id { print $2 }' | sort -n | tr '\n' '|' | sed 's/|$/\n/')
		echo "$movie_ids"
		movie_ids2=$(cat u.data | awk -v user_id="$user_id" '$1 == user_id { print $2 }' | sort -n| head)
		echo
		for i in $movie_ids2
		do
			cat u.item | awk -F '|' -v id="$i" '$1 == id { print $1 "|" $2 }'
		done
		echo
		;;
	8)
		echo
                read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n):" answer
                echo
                if [ $answer = 'y' ]
                then
                    user_ids=$(awk -F'|' '$2 >= 20 && $2 <= 29 && $4 == "programmer" {print $1}' u.user)
                         for user_id in $user_ids
                         do
				 awk -v ui=$user_id -F'\t' '$1==ui  { total[$2] += $3; num[$2]++ } END { for (i in total) if (num[i]>0) print i, total[i]/num[i] }' u.data
                         done |  awk '{ total[$1] += $2; num[$1]++ } END { for (i in total) if (num[i]> 0) print i, total[i]/num[i] }'
                fi
                echo
                ;;
	9)
		echo
		echo "Bye!!"
		exit 0
		;;
	*)
		echo "ERROR:CHOOSE OTHER NUMBER"
		;;
	esac
done
