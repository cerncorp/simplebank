postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=admin -d postgres:12-alpine

mysql:
	docker run --name mysql8 -p 3306:3306  -e MYSQL_ROOT_PASSWORD=admin -d mysql:8

createdb:
	docker exec -it postgres12 createdb --username=postgres --owner=postgres simplebank

dropdb:
	docker exec -it postgres12 dropdb simplebank

migrateup:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5432/simplebank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5432/simplebank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5432/simplebank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://postgres:admin@localhost:5432/simplebank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/techschool/simplebank/db/sqlc Store

.PHONY: postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 sqlc test server mock