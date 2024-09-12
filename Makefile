start-all:
	cd nd-common-infra && make init
	cd nd-go-app && make init
	cd nd-laravel-app && make init
