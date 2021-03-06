# Creating DB in Heroku

This assumes you've already created an app in heroku.

## Create Database in Heroku

```bash
heroku addons:create heroku-postgresql:hobby-dev
```

## Update DB Environment Variables

Get your connection config by running `heroku pg:credentials:url`. This will give you something like:

```bash
Connection information for default credential.
Connection info string:
   "dbname=d5h4602ejfseiv host=ec2-54-243-47-196.compute-1.amazonaws.com port=5432 user=jwgaa6b0dcb9yfs password=12345678901234567890abcdefghijklmnopqrstuvwxyz sslmode=require"
Connection URL:
   postgres://jwgaa6b0dcb9yfs:12345678901234567890abcdefghijklmnopqrstuvwxyz@ec2-54-243-47-196.compute-1.amazonaws.com:5432/d5h4602ejfseiv
```

Take the information from the connection string and export the following environment variables so that they're available to in your local environment:

```bash
export WARTHOG_DB_HOST=ec2-54-243-47-196.compute-1.amazonaws.com
export WARTHOG_DB_DATABASE=d5h4602ejfseiv
export WARTHOG_DB_USERNAME=jwgaa6b0dcb9yfs
export WARTHOG_DB_PASSWORD=12345678901234567890abcdefghijklmnopqrstuvwxyz
```

This will make your secrets available locally. To add them to Heroku so that your app server can connect to your DB server, do use heroku config to add the ENV vars to Heroku:

```bash
heroku config:set WARTHOG_DB_HOST=ec2-54-243-47-196.compute-1.amazonaws.com
heroku config:set WARTHOG_DB_DATABASE=d5h4602ejfseiv
heroku config:set WARTHOG_DB_USERNAME=jwgaa6b0dcb9yfs
heroku config:set WARTHOG_DB_PASSWORD=12345678901234567890abcdefghijklmnopqrstuvwxyz
```

## Build app and migrate database

```bash
yarn build && WARTHOG_ENV=development:prod-like yarn run config && yarn warthog db:migrate
```

## Run the server and issue a query

Run `yarn start` and navigate to [http://localhost:4100/graphql](http://localhost:4100/graphql)

Run the following query to make sure everything is wired up correctly:

```graphql
query {
  users {
    id
    firstName
    lastName
    createdAt
  }
}
```

If you see the following response, you're good:

```graphql
{
  "data": {
    "users": []
  }
}
```

## Configuring with CircleCI

Add a command to your `config.yml`:

```
  - run:
      name: deploy
      command: |
        git push https://heroku:$HEROKU_API_KEY@git.heroku.com/$HEROKU_APP_NAME.git master
```

Then go to the project settings --> environment variables (https://circleci.com/gh/goldcaddy77/warthog-starter/edit#env-vars) and add:

- HEROKU_API_KEY - To get an API key, run `heroku authorizations:create`
- HEROKU_APP_NAME - `warthog-starter`
