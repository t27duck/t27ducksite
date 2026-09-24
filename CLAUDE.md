# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

t27duck.com — Tony Drake's personal site and blog. Rails 8.1 on Ruby 4.0, SQLite, importmap + Hotwire, Propshaft assets, deployed to a single server with Kamal. No Action Mailer, Action Cable, or Action Mailbox (they're commented out in `config/application.rb`).

## Commands

```bash
bin/setup --skip-server        # install gems, prepare DB, clear logs (idempotent)
bin/dev                        # start the server (== bin/rails server)
bin/ci                         # full local CI pipeline (see config/ci.rb)

bin/rails test                 # unit + integration tests
bin/rails test:system          # system tests (needs Chrome/Selenium)
bin/rails test test/models/post_test.rb        # single file
bin/rails test test/models/post_test.rb:12     # single test by line

bin/rubocop                    # Ruby lint (bin/rubocop -a to autocorrect)
npx --yes @herb-tools/linter   # ERB lint (config in .herb.yml)
bin/brakeman --no-pager        # static security scan
bin/bundler-audit              # gem CVE audit
bin/importmap audit            # JS dependency audit
```

`bin/ci` runs setup, RuboCop, all three security scans, both test suites, and `db:seed:replant` in the test env. GitHub Actions (`.github/workflows/ci.yml`) runs the same checks as separate jobs.

## Architecture notes

**Single-user auth, no sessions table.** There is exactly one `User` row. `SessionsController#create` does `User.take` and checks only the password — there's no email/username. Sign-in sets a signed permanent cookie holding `user.token` (`has_secure_token`); `ApplicationController#user_signed_in?` looks that token up. Admin controllers gate on `before_action :authenticate_user!`. Tests call the `login_user` helper in `test/test_helper.rb`, which posts `TEST_ENV_PASSWORD` to `session_path`.

Setting the password is a console operation — `User.create!(password: "...")` on a fresh DB, or `User.first.update!(password: "...")`. There's no rake task or seed for it.

**Posts and talks are the same model.** `Post#kind` is `"post"` or `"talk"`. `PostsController` filters `kind: "post"`, `TalksController` filters `kind: "talk"`. A talk carries a `video_url` and no `content` (validations are conditional on `talk?`); `posts/_post.html.erb` branches to `posts/_video.html.erb`, which builds the YouTube embed from `Post#youtube_id`. `Post::YOUTUBE_URL` is anchored and https-only so a `video_url` can't inject a `javascript:` href. Publishing is a nullable `published_at` timestamp exposed to forms through the virtual `publish` / `publish=` accessors; `Post.published` / `Post.unpublished` scope on it. `Post#to_param` is `"#{id}-#{title}".parameterize`.

**Tags are parameterized on write.** `Tag#name=` calls `.parameterize` on the value, so tag lookups always use the slug form. Admin forms take a comma-separated string through `Post#tags_input=`, which finds-or-creates each tag.

**Rich text is Action Text + Lexxy.** `Page#content` and `Post#content` are `has_rich_text`, edited with `f.rich_text_area`. `Project#description` is plain HTML in a column. There is no markdown anywhere anymore — both `marksmith` and `commonmarker` are gone.

**Old migrations are historical records, not a replayable path — don't "fix" them.** `db/schema.rb` is the source of truth for creating a database; `db:prepare` loads it for a new one and only runs pending migrations on an existing one. Several migrations can no longer run: the three markdown-conversion ones (`convert_project_descriptions_to_html`, `move_page_content_to_action_text`, `move_post_content_to_action_text`) call `Commonmarker`, which is no longer bundled, and `20241223182145_migrate_talks_to_posts.rb` calls `Talk.all` whose model was deleted by the very next migration. All of them have already run in production.

`app/views/layouts/action_text/contents/_content.html.erb` overrides the wrapper to `class="lexxy-content"` (the gem default is `trix-content`, which Lexxy's CSS doesn't match) and hangs the `syntax-highlight` Stimulus controller off it — Lexxy bundles Prism but only auto-highlights inside the editor. `config/initializers/action_text.rb` adds `<s>`/`<u>` and `target`/`rel` to the sanitizer allowlist, which neither Rails nor Lexxy includes; it has to use `ActiveSupport.on_load(:action_text_content)` because Lexxy's engine *assigns* those lists rather than appending. Code blocks are `<pre data-language="x">` with `<br>` line breaks; Lexical reads the language from `data-language` only. Embedded images are real Action Text attachments rendered through `app/views/active_storage/blobs/_blob.html.erb`, which only emits a `<figcaption>` when there's an explicit caption or the file isn't previewable. The `lexxy` gem is pinned exactly because it is pre-1.0 and monkey-patches Action Text's form helpers — `test/system/admin/pages_test.rb` and `posts_test.rb` guard that.

**ReActionView is on.** `config.intercept_erb = true` means `.html.erb` templates compile through `Herb::Engine`, not stock ERB.

**Helpers are not globally included.** `config.action_controller.include_all_helpers = false` and generators are configured with `g.helper = false`, so `app/helpers` holds only `ApplicationHelper` (available everywhere via ApplicationController); per-controller helpers would need explicit inclusion.

**Page-level metadata via ivars.** `app/views/layouts/application.html.erb` reads `@page_title`, `@page_description`, `@page_type`, and `@no_content` — controllers set these; there's no metadata DSL.

**Feed.** `/posts.xml` renders `app/views/posts/index.xml.builder` with `layout: false`.

## Conventions

- RuboCop config (`.rubocop.yml`) is the style authority: double-quoted strings, bracketed symbol/word arrays, **no** `# frozen_string_literal` magic comments (Ruby 4 freezes by default; `StringLiteralsFrozenByDefault: true`), expanded empty methods (`def foo\nend`).
- Controllers separate public actions from private ones with `private ######...` banner comments — match that when editing existing controllers.
- Strong params use Rails 8 `params.expect(...)`, not `require/permit`.
- Failed create/update renders use `status: :unprocessable_content`.
- Tests are Minitest with fixtures (`fixtures :all`, parallelized). Controller tests live in `test/integration/`, not `test/controllers/`.

## Environment & deploy

`.env` (gitignored) holds `SERVER_HOST`, `PROXY_*`, `SSH_USERNAME`, `SECRET_KEY_BASE`; `config/deploy.yml` loads it via dotenv for Kamal. Optional `GA_TAG_ID` enables the Google Analytics snippet in the layout. Development runs in a devcontainer (`.devcontainer/`) with a separate Selenium service — system tests read `CAPYBARA_SERVER_PORT` and `SELENIUM_HOST` to switch to the remote driver.
