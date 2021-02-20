$PROJECT=alcanzapoesia_test

docker-compose -p ${PROJECT} down
docker-compose -p ${PROJECT} up -d --build