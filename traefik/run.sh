PROJECT=alcanzapoesia

docker-compose -p ${PROJECT} down
docker-compose -p ${PROJECT} up -d --build
