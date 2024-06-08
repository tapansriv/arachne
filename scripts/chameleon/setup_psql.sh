sudo apt update
sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql # start database
sudo systemctl status postgresql # shows status of launch
echo "SHOW data_directory;" | sudo -u postgres psql # enter interactive postgres prompt
sudo systemctl stop postgresql # shuts down postgres





# echo "CREATE USER cc WITH superuser;" | sudo -u postgres psql
