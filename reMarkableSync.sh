#!/bin/bash
# v1.3

if [[ -e "/tmp/reMarkableSync.pid" ]] ; then
    echo "another is running, exit"
else

touch "/tmp/reMarkableSync.pid"

cartella="/home/mm/reMarkable-autosync/Sincronizza"

cd /home/mm/reMarkable-autosync/Sincronizza

rclone move nextcloud:/invia_a_marco/ /home/mm/reMarkable-autosync/Sincronizza/

for f in *\ *; do mv "$f" "${f// /_}" 2> /dev/null; done

for f in *; do
    test -f "$f" && mv "$f" "${f,,}"
done

mv *.PDF *.pdf 2> /dev/null
mv *.ZIP *.zip 2> /dev/null

for filename in /home/mm/reMarkable-autosync/Sincronizza/*.zip; do

    [ -f "$filename" ] || continue
    basenamepdf="${filename##*/}"
    echo "elaboro il file $basenamepdf $filename" >> /tmp/reMarkable.log
    unzip -o "$filename"
    rm "$filename"

done

cd /home/mm/reMarkable-autosync/
test -f *.pdf && /home/mm/reMarkable-autosync/rmapi mkdir Upload/"$(date +"%d-%m-%Y")"

for filename in /home/mm/reMarkable-autosync/Sincronizza/*.pdf; do

    [ -f "$filename" ] || continue
    basenamepdf="${filename##*/}"
    echo "elaboro il file $basenamepdf $filename"  >> /tmp/reMarkable.log

######################
#uncomment for remarkable api
#    php /home/mm/reMarkable-autosync/remarkable.php upload "Sincronizza/$basenamepdf" Upload

#uncomment for rmapi
    /home/mm/go/bin/rmapi put "Sincronizza/$basenamepdf" Upload
######################

    sleep 5
    rm "Sincronizza/$basenamepdf"
    echo "$filename" >> /tmp/sincronizzati

done

rclone move /home/mm/reMarkable-autosync/Sincronizza/ nextcloud:/scartati_da_marco/

rm "/tmp/reMarkableSync.pid"

fi
