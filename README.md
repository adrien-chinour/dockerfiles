# Docker PHP utils images

## Images

See [Packages section](https://github.com/adrien-chinour?tab=packages)

- `ghcr.io/adrien-chinour/php-cli-xdebug` : PHP CLI image with xdebug
- `ghcr.io/adrien-chinour/php-cli-allinclusive`: PHP CLI image with commonly used extensions
- `ghcr.io/adrien-chinour/phpstan`: PHP CLI image with phpstan

> [!TIP]
> All images has composer installed

### Tags

Each image is published as `<php version>-<debian codename>`:

| PHP | Debian                 |
|-----|------------------------|
| 7.4 | `7.4-bullseye` (EOL)   |
| 8.4 | `8.4-trixie`           |
| 8.5 | `8.5-trixie`           |

_PHP 7.4 official images only exist on Debian 11 (bullseye), which is end-of-life: its packages are fetched from `archive.debian.org`._

> [!WARNING]
> The `*-alpine` tags are deprecated since 2026-11-04: they are no longer rebuilt nor scanned. Switch to the Debian tags.

### Security

- Images are rebuilt and published **every day** to pick up base image and package security updates.
- Every build is scanned with [Trivy](https://trivy.dev): an image with a fixable `CRITICAL` or `HIGH`
  vulnerability is not published. Full reports are available in the
  [code scanning alerts](https://github.com/adrien-chinour/dockerfiles/security/code-scanning).
- The Dockerfile is linted with hadolint, the workflows with actionlint and audited with zizmor.

## Usage

### Run composer

```shell
# Run composer install with any php version. 
# Example 8.4 : ghcr.io/adrien-chinour/php-cli-xdebug:8.4-trixie
docker run -v .:/opt -u $(id -u):$(id -g) ghcr.io/adrien-chinour/php-cli-xdebug:8.4-trixie composer install 
```

_`WORKDIR` is `/opt` on each images use `-v` to map your current dir with `/opt`._

## Intellij/PHPStorm integration

If you want to run php commands on IntelliJ for PHPUnit or Composer you will need a PHP interpreter.

On Settings > Languages and Framework > PHP define a new interpreter from Docker :

![PHP interpreter](docs/interpreter.png)
