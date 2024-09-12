start-all:
	cd nd-common-infra && make up
	cd nd-go-app && make up
	cd nd-laravel-app && make up
