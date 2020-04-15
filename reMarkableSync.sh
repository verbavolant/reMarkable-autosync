#!/bin/bash

if [[ -e "/tmp/reMarkableSync.pid" ]] ; then
    echo "another is running, exit"
else

touch "/tmp/reMarkableSync.pid"

cartella="/home/mm/remarkable/Sincronizza"

cd /home/mm/remarkable/Sincronizza

rclone move nextcloud:/invia_a_marco/ /home/mm/remarkable/Sincronizza/

mv *.PDF *.pdf 2> /dev/null
mv *.ZIP *.zip 2> /dev/null

for filename in /home/mm/remarkable/Sincronizza/*.zip; do

    [ -f "$filename" ] || continue
    basenamepdf="${filename##*/}"
    echo "elaboro il file $basenamepdf $filename"
    unzip -o "$filename"
    rm "$filename"

done

cd /home/mm/remarkable

for filename in /home/mm/remarkable/Sincronizza/*.pdf; do

    [ -f "$filename" ] || continue
    basenamepdf="${filename##*/}"
    echo "elaboro il file $basenamepdf $filename"
    php /home/mm/remarkable/remarkable.php upload "Sincronizza/$basenamepdf" Upload
    sleep 5
    rm "Sincronizza/$basenamepdf"
    echo "$filename" >> /tmp/sincronizzati

done

rclone move /home/mm/remarkable/Sincronizza/ nextcloud:/scartati_da_marco/

rm "/tmp/reMarkableSync.pid"

fi
