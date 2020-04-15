# reMarkable-autosync
Sync a Nextcloud folder with reMarkable automagically

Needed:
* API used by the reMarkable Paper Tablet for syncing documents between the device, the desktop and mobile clients and the cloud service https://github.com/splitbrain/ReMarkableAPI

* rclone
* nextcloud (or other service compatible with rclone)

Create a nextcloud directory for import (/invia_a_marco in the example) and one for export (/scartati_da_marco in the example)
Create a cron in /etc/cron.d: "* * * * * user /home/user/remarkable/reMarkableSync.sh" (here, every minute)
