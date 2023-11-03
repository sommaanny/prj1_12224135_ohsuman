echo "--------------------------"
echo "User Name: suman OH"
echo "Student Number: 12224135"
echo "[ MENU ]"
echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
echo "2. Get the data of action genre movies from 'u.item'"
echo "3. Get the average 'rating' of the moive identified by specific 'movie id' from 'u.data'"
echo "4. Delete the 'IMDb URL' from 'u.item'"
echo "5. Get the data about users from 'u.user'"
echo "6. Modifiy the format of 'release data' in 'u.item'"
echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
echo "8. Get the average 'rating' of moives rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
echo "9. Exit"
echo "--------------------------"
stop="N"
until [ $stop = "Y" ]
do
	read -p "Enter your choice [ 1-9 ] " choice
	echo
	case $choice in
	1)
		read -p "Please enter 'movie id'(1~1682):" id
		echo
		awk -v ID=$id 'NR == ID {print $0}' ./u.item
		echo
		;;
	2)
		read -p "Do you want to get the data of 'action' genre movie from 'u.item'?(y/n) :" answer
		echo
		if [ "$answer" = "y" ]
		then
			awk -F"|" 'BEGIN {count = 0} $7 == 1 {if (count < 10) {print $1, $2; count++}}' ./u.item
			echo
		else
			continue
		fi
		;;
	3)
		read -p "Please enter the 'movie id'(1~1682):" id
		echo
		awk -v ID=$id 'BEGIN{sum=0; i=0;} $2 == ID {sum+=$3; i++} END{avg = sum / i; print "average rating of", ID, ":", avg}' ./u.data
		echo
		;;
	4)
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'?(y/n) :" answer
		echo
		if [ "$answer" = "y" ]
		then
			sed -n '1,10{s/http[^)]*)//g;p;}' u.item
			echo
		else
			continue
		fi
		;;
	5)
		read -p "Do you want to get the data about users from 'u.user'?(y/n) :" answer
		echo
		if [ "$answer" = "y" ]
		then
			sed -n -E '1,10 s/^([0-9]+)\|([0-9]+)\|([MF])\|([^|]+)\|([0-9]+)$/user \1 is \2 years old \3 \4/p' u.user | sed -e 's/M/male/g' -e 's/F/female/g'
			echo
		else
			continue
		fi
		;;
	6)
		read -p "Do you want to Modify the format of 'release data in 'u.item'?(y/n) :" answer
		echo
		if [ "$answer" = "y" ]
		then
			sed -n '1673,1682 s/\([0-9]\{2\}\)-\([A-Z][a-z]\{2\}\)-\([0-9]\{4\}\)/\3\2\1/p' u.item | sed -e 's/Jan/01/g' -e 's/Oct/10/g' -e 's/Sep/09/g' -e 's/Feb/02/g' -e 's/Mar/03/g'
			echo
		else
			continue
		fi
		;;
	7)
		read -p "Please enter the 'user id'(1~943) :" id
		echo
		awk -v ID=$id '$1 == ID {print $2}' u.data | sort -n | tr '\n' '|' | sed 's/|$//'
		echo
		echo
		awk -v ID=$id '$1 == ID {print $2}' u.data | sort -n > output.txt
		IFS=$'\n' read -d '' -r -a dataArray < output.txt
		for index in {0..9}; do
			data="${dataArray[$index]}"
			awk -v DATA=$data -F '|' '$1 == DATA {print $1, $2}' u.item | sed 's/ /|/'
		done
		echo
		;;
	8)
		read -p  "Do you want to get the average 'rating' of moives rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(y/n) :" answer
		echo
		if [ "$answer" = "y" ]
		then
			awk -F '|' '{if($2 > 19 && $2 < 30 && $4 == "programmer") {print $1}}' u.user > user_ids.txt
			awk -F '	' 'FNR==NR {user_ids[$1]; next} $1 in user_ids {print $2, $3}' user_ids.txt u.data > user_ratings.txt
			awk '{sums[$1] += $2; counts[$1] += 1} END {for (movie_id in sums) {print movie_id, sums[movie_id] / counts[movie_id]}}' user_ratings.txt > movie_avg_ratings.txt
			sort -n -k1,1 movie_avg_ratings.txt
			echo
		else
			continue
		fi
		;;
	9)
		echo "Bye!"
		stop="Y"
		;;
	*)
		echo "Error: Invalid option..."
		 read -p "Press [Enter]..." readEnterKey
		;;
	esac
done

	
