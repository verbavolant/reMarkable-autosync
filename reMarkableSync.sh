#!/bin/bash
# v1.4

if [[ -e "/tmp/reMarkableSync.pid" ]] ; then
    echo "another is running, exit"
else

touch "/tmp/reMarkableSync.pid"

cartella="/home/marco/reMarkable-autosync/Sincronizza"

cd /home/marco/reMarkable-autosync/Sincronizza

rclone move nextcloud:/invia_a_marco/ /home/marco/reMarkable-autosync/Sincronizza/
#add another sync point
#rclone move xxxx:xxxx /home/marco/reMarkable-autosync/Sincronizza/

for f in *\ *; do mv "$f" "${f// /_}" 2> /dev/null; done

for f in *; do
    test -f "$f" && mv "$f" "${f,,}"
done

for filename in /home/marco/reMarkable-autosync/Sincronizza/*.zip; do

    [ -f "$filename" ] || continue
    basenamepdf="${filename##*/}"
    echo "elaboro il file $basenamepdf $filename" >> /tmp/reMarkable.log
    unzip -o "$filename"
    rm "$filename"
done

mv *.PDF *.pdf 2> /dev/null
mv *.ZIP *.zip 2> /dev/null

cd /home/mm/reMarkable-autosync/
test -f *.pdf && /home/mm/reMarkable-autosync/rmapi mkdir Upload/"$(date +"%d-%m-%Y")"

for filename in /home/mm/reMarkable-autosync/Sincronizza/*.pdf; do

    [ -f "$filename" ] || continue
    basenamepdf="${filename##*/}"
    /home/marco/reMarkable-autosync/rmapi mkdir Upload/"$(date +"%Y-%m-%d")"
    echo "elaboro il file $(date +"%Y-%m-%d") $basenamepdf $filename"  >> /tmp/reMarkable.log
    
######################
#uncomment for remarkable api
#    php /home/marco/reMarkable-autosync/remarkable.php upload "Sincronizza/$basenamepdf" Upload

#uncomment for rmapi
    /home/marco/reMarkable-autosync/rmapi put "Sincronizza/$basenamepdf" Upload/"$(date +"%Y-%m-%d")"  >> /tmp/rmapi.log
######################

    sleep 5
    rm "Sincronizza/$basenamepdf"
    echo "$filename" >> /tmp/sincronizzati

done

rclone move /home/mm/reMarkable-autosync/Sincronizza/ nextcloud:/scartati_da_marco/

rm "/tmp/reMarkableSync.pid"

fi
