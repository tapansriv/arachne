sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install postgresql

# run this in side of psql to add user. then generate the CSVs from parquet
# files. Then move those to /var/lib/postgresql and run test.sql in postgres to
# generate the tables and copy them inside.

# sudo -i -u postgres
# CREATE USER cc WITH SUPERUSER PASSWORD 'admin'
