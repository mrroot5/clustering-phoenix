.PHONY: iex

iex:
	@docker compose exec web sh -c 'iex --cookie web --sname console --remsh web_$$(hostname)@$$(hostname)'

bash:
	@docker exec -it clustering_phoenix-web-1 /bin/bash