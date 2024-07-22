NAME = inception

all : $(NAME)
$(NAME) :
	sudo mkdir -p /home/haeem/data/wp-db /home/haeem/data/wp-webfiles
	sudo chmod 777 /etc/hosts
	sudo echo "127.0.0.1 haeem.42.fr" >> /etc/hosts
	docker compose --env-file srcs/.env -f srcs/docker-compose.yml up --build -d


clean :
	docker compose -f srcs/docker-compose.yml down -v --rmi all --remove-orphans

ps :
	docker compose -f srcs/docker-compose.yml ps

logs :
	docker compose -f srcs/docker-compose.yml logs -f

fclean : clean
	sudo rm -rf /home/haeem/data
	docker system prune --volumes --all --force
	docker network prune --force
	docker volume prune --force
	sudo sed -i "/127.0.0.1 haeem.42.fr/d" /etc/hosts

re : fclean all

restart :
	docker compose -f srcs/docker-compose.yml restart

.PHONY : all clean ps log fclean re restart
