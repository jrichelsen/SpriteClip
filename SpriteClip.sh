#!/bin/bash
# Jon Richelsen
# CSE20212
# 1943_Project
# SpriteClip.sh
# 	Takes user-inputted name and coordinates for sprites and formats them into SDL_Rect structs
# Created	03/24/14
# Edited	03/27/14 Added file input method
# Edited	03/28/14 Debugged and finished file input method

# Ideas for improvement
# - Use shell pattern matching (like regular expression) for "y/n" prompt
# - Use subfunction for "y/n" prompts
# - Use subfunction for handling file extension
# - Use nicer exit method
# - Reduce code reuse in regards to different input methods


# Print script information to terminal
cat <<- DONE1
	
	SpriteClip 14.03.1-3
	Jon Richelsen (jrichelsen@gmail.com)
	Visit me at jonrichelsen.com
	Takes user-inputted name and coordinates for sprites and formats them into SDL_Rect structs
	------------------------------
DONE1


# Get filename and create output file
echo -n "Filename of output file: "
read outFile


# Add ".txt" extension if output file has no extension
hasExt=`echo "$outFile" | grep '\..*'`
if [ -z "$hasExt" ]; then
	outFile="$outFile"".txt"
fi


# Check if output file exists and if user wants to overwrite
while [ -e "$outFile" ]; do
	echo -n "$outFile already exists. Overwrite? (y/n): "
	read inp1
	case "$inp1" in
		"y" | "Y" | "yes" | "Yes" | "YES")
			rm "$outFile"
			;;
		"n" | "N" | "no" | "No" | "NO")
			echo -n "Filename of output file: "
			read outFile
			
			# Add ".txt" extension if output file has no extension
			hasExt=`echo "$outFile" | grep '\..*'`
			if [ -z "$hasExt" ]; then
				outFile="$outFile"".txt"
			fi
			;;
	esac
done


# Overwrite output file with script information header
cat <<- DONE2 > "$outFile"
	Created with SpriteClip 14.03.1-3
	Jon Richelsen (jrichelsen@gmail.com)
	Visit me at jonrichelsen.com
	Takes user-inputted name and coordinates for sprites and formats them into SDL_Rect structs
	------------------------------
DONE2

# Check if user wants to use file input mode
echo -n "Would you like to use file input mode? (y/n): "
read inp2
case "$inp2" in
	"y" | "Y" | "yes" | "Yes" | "YES")
		inMode=1
		;;
	"n" | "N" | "no" | "No" | "NO")
		inMode=0
		;;
esac


# Gather user input
if [ $inMode -eq 1 ]; then
	while read line; do
		name=`echo $line | awk '{print $1}'`
		com=`echo $line | awk -F// '{print $2}'`
		
		echo "------------------------------"
		
		echo -n "$name upper-left x: "
		read ULxPos < /dev/tty
	
		echo -n "$name upper-left y: "
		read ULyPos < /dev/tty
	
		echo -n "$name lower-right x: "
		read LRxPos < /dev/tty
	
		echo -n "$name lower-right y: "
		read LRyPos < /dev/tty
	
		let width=$LRxPos-$ULxPos+1
		let height=$LRyPos-$ULyPos+1
	
		echo "SDL_Rect $name; //$com" >> "$outFile"
		echo "$name.[x] = $ULxPos;" >> "$outFile"
		echo "$name.[y] = $ULyPos;" >> "$outFile"
		echo "$name.[w] = $width;" >> "$outFile"
		echo "$name.[h] = $height;" >> "$outFile"
		echo "" >> "$outFile"
		
		let cnt=$cnt+1
	done < "Sprite_Map.txt"
else
	cnt=1
	doRun=1
	while [ $doRun -ne 0 ]; do
		echo "------------------------------"
		
		echo -n "Sprite $cnt name: "
		read name
		
		echo -n "$name comment: "
		read com
	
		echo -n "$name upper-left x: "
		read ULxPos
	
		echo -n "$name upper-left y: "
		read ULyPos
	
		echo -n "$name lower-right x: "
		read LRxPos
	
		echo -n "$name lower-right y: "
		read LRyPos
	
		let width=$LRxPos-$ULxPos+1
		let height=$LRyPos-$ULyPos+1
	
		echo "SDL_Rect $name; //$com" >> "$outFile"
		echo "$name.[x] = $ULxPos;" >> "$outFile"
		echo "$name.[y] = $ULyPos;" >> "$outFile"
		echo "$name.[w] = $width;" >> "$outFile"
		echo "$name.[h] = $height;" >> "$outFile"
		echo "" >> "$outFile"

		let cnt=$cnt+1
	done	
fi
