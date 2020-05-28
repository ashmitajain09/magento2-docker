COMPOSE_INTERACTIVE_NO_CLI=1
docker-compose up -d --build

docker exec -ti web bash < magento.sh

echo "Great"

