echo 'show databases' | mysql -h$DB_HOST -u$DB_USER -p$DB_PASS | grep cities
if [ $? -eq 0 ]; then exit 0 ; fi
for i in  schema app-user master-data; do
  mysql -h$DB_HOST -u$DB_USER -p$DB_PASS < $i.sql
done

