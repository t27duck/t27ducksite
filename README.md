# t27duck.com

Source for [t27duck.com](https://t27duck.com), Tony Drake's personal site and blog. It runs on Rails 8.1, Ruby 4.0, and SQLite, and deploys with Kamal.

## Development

```bash
bin/setup --skip-server   # install gems and prepare the database
bin/dev                   # start the server
bin/ci                    # run linters, security scans, and tests
```

To set the admin password, run `User.create!(username: "admin", password: "...")` in `bin/rails console`.

## Deploy

Put `SERVER_HOST`, `PROXY_*`, `SSH_USERNAME`, and `SECRET_KEY_BASE` in `.env`, then run `bin/kamal deploy`.
