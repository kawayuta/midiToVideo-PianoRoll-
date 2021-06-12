#!/bin/bash
 
while getopts m:t:a:c: OPT
do
  case $OPT in
    m) m_path=$OPTARG
       ;;
    t) t_num=$OPTARG
       ;;
    a) a_num=$OPTARG
       ;;
    c) c_title=$OPTARG
       ;;
  esac
done
 
case $c_title in
  "pink") echo "pink"
     ;;
  "blue") echo "blue"
     ;;
  "yellow") echo "yellow"
     ;;
esac

echo ${m_path}
command ./MIDIVisualizer-cli --midi ${m_path} --size 1280 720 --config ./config/${c_title}.ini --export video_${t_num}.mp4 --format MPEG4
command timidity -OwS ${m_path} -o ./output_${t_num}.wav
command convert -gravity center -font "/System/Library/Fonts/ヒラギノ丸ゴ ProN W4.ttc" \
                    -size 1280x720 \
                    -fill "#FFFFFF" \
                    -background none \
                    -pointsize 120 \
                    caption:${t_num} \
                    textImage_${t_num}.png
command ffmpeg -i video_${t_num}.mp4 -loop 1 -i textImage_${t_num}.png -filter_complex "[1]format=yuva420p,lut=a='val*0.9',fade=in:st=0:d=2:alpha=1,fade=out:st=3:d=2:alpha=1[a];[0][a] overlay=(W-w)/2:(H-h)/2:shortest=1" -movflags +faststart -pix_fmt yuv420p -c:v libx264 -crf 20 "output_${t_num}.mp4"
command ffmpeg -y -i output_${t_num}.mp4 -itsoffset 00:00:01 -i output_${t_num}.wav -vcodec copy "${t_num} - ${a_num}【Piano Cover】".mp4
command rm -rf output_${t_num}.wav
command rm -rf output_${t_num}.mp4
command rm -rf video_${t_num}.mp4
command rm -rf textImage_${t_num}.png