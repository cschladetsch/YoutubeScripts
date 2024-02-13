#!/bin/bash

if [ "$1" == "" ]; then
     echo "Require an input file."
     exit 1
fi

input="$1"
output="$input.out.mp4"

if [ $# -le 2 ]; then
    output="latest.mp4"
fi

# Function to calculate the ratio
calculate_ratio() {
    size1=$(stat -c "%s" "$input")
    size2=$(stat -c "%s" "$output")

    if [ "$size2" -ne 0 ]; then
        ratio=$(bc <<< "scale=2; $size1 / $size2")
    else
        ratio="Undefined (division by zero)"
    fi

    echo "Input file size: $size1 bytes"
    echo "Output file size: $size2 bytes"
    echo "Ratio (Input / Output): $ratio"
}

# Run FFmpeg command to scale the input video
# ffmpeg -i "$input" -y -vf "scale=1920:1080" -c:v libx264 -preset veryfast -crf 18 -c:a copy "$output"

ffmpeg -hwaccel cuda -i "$input" -y -vf "scale=1920:1080" -c:v h264_nvenc -preset p4 -rc vbr -cq 19 -b:v 5M -maxrate:v 10M -bufsize:v 10M -c:a copy "$output"

echo "---- Results written to $output from $input$ ----"
ls -l $outout $input
echo "-------------------------------------------------"


# Call the calculate_ratio function to calculate and print the ratio
#calculate_ratio

