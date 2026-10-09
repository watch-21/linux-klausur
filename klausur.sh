#!/bin/bash
# linux-klausur.sh - Einrichtung fuer Elbwerft GmbH
# Start: sudo ./linux-klausur.sh

# 1.Update

echo "1. Update und Upgrade"
sleep 2
apt update
apt upgrade -y
apt install -y tree ncdu git

# 2.benutzer und Date

echo "2.Benutzer und Date"
sleep 2

useradd -m -s /bin/bash jana
useradd -m -s /bin/bash yusuf
useradd -M -s /bin/bash kim

groupadd leitung
groupadd werft

usermod -aG werft,leitung,sudo jana
usermod -aG werft yusuf
usermod -aG werft kim

mkdir -p /home/jana/Team /home/jana/Logs
mkdir -p /home/yusuf/Dokumente /home/yusuf/Backup
mkdir -p /srv/halle

chown -R jana:leitung /home/jana/Team /home/jana/Logs
chown -R yusuf:werft /home/yusuf/Dokumente /home/yusuf/Backup
chown kim:werft /srv/halle
chmod 770 /srv/halle

# Die Zugangsdaten

git clone http://94.16.105.22:8080/pruefung/zugaenge.git /home/jana/Team/Zugangsdaten

chown -R jana:leitung /home/jana/Team/Zugangsdaten
chmod 700 /home/jana/Team/Zugangsdaten
chmod 600 /home/jana/Team/Zugangsdaten/jana.txt /home/jana/Team/Zugangsdaten/yusuf.txt /home/jana/Team/Zugangsdaten/kim.txt

chpasswd < /home/jana/Team/Zugangsdaten/jana.txt
chpasswd < /home/jana/Team/Zugangsdaten/yusuf.txt
chpasswd < /home/jana/Team/Zugangsdaten/kim.txt

# 3.Alias, Variable und versteckte Datei

echo "3. Alias, Variable und versteckte Datei"
sleep 2

echo "alias update_sys='sudo apt update && sudo apt upgrade -y'" >> /home/jana/.bashrc
echo 'export FIRMA="Elbwerft GmbH"' >> /home/jana/.bashrc
chown jana:jana /home/jana/.bashrc

touch /home/jana/.werft
chown jana:jana /home/jana/.werft

# 4.Cronjobs

echo "4. Cronjobs"
sleep 2

# Sonntag 00:00: Dokumente nach Backup kopieren
echo '0 0 * * 0 cp -r /home/yusuf/Dokumente /home/yusuf/Backup/' > /tmp/yusuf-jobs.txt
crontab -u yusuf /tmp/yusuf-jobs.txt

# Alle 20 Minuten: Datum an die versteckte Datei anhaengen
echo '*/20 * * * * date >> /home/jana/.zeitlog' > /tmp/jana-jobs.txt
crontab -u jana /tmp/jana-jobs.txt

# Alle 8 Stunden: Inhalt von /srv/halle loeschen
echo '0 */8 * * * find /srv/halle -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +' > /tmp/kim-jobs.txt
crontab -u kim /tmp/kim-jobs.txt

# 5.Abschluss

echo "5. Abschluss"

sleep 2


echo 5

sleep 1

echo 4

sleep 1

echo 3

sleep 1

echo 2

sleep 1

echo 1

sleep 1

reboot
