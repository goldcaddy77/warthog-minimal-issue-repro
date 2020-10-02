# import .env file
set -a
. ./.env >/dev/null 2>&1
set +a

WARTHOG_ENV=test yarn dotenv:generate
yarn db:drop
yarn db:create
yarn jest --verbose
