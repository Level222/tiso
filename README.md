# tiso

Display timestamp in ISO 8601 format.

## System Requirements

### Required

- POSIX shell
- POSIX-compliant commands

### Optional

- [GNU Date](https://www.gnu.org/software/coreutils/manual/html_node/date-invocation.html) ([GNU Core Utilities](https://www.gnu.org/software/coreutils/))
  - To use `%N` format (nano seconds)

## Installation

1. Clone this repository.

2. Make the command available. For example, there are three different ways:

   - Copy file

      ```shell
      cd path/to/tiso # Cloned repository
      install_file=/usr/local/bin/tiso # Can be changed
      sudo cp bin/tiso "$install_file"
      sudo chmod +x "$install_file"
      ```

      Uninstall:

      ```shell
      install_file=/usr/local/bin/tiso # Can be changed
      sudo rm "$install_file"
      ```

   - Symbolic link

      ```shell
      cd path/to/tiso # Cloned repository
      symlink_file=/usr/local/bin/tiso # Can be changed
      sudo ln -s "$(pwd)/bin/tiso" "$symlink_file"
      ```

      Uninstall:

      ```shell
      symlink_file=/usr/local/bin/tiso # Can be changed
      sudo rm "$symlink_file"
      ```

   - Alias

      1. Open rc file in editor. (`~/.bashrc` for bash, `~/.zshrc` for zsh)

      2. Add an alias of `bin/tiso` to the file.

          ```shell
          alias tiso="path/to/bin/tiso"
          ```

      Uninstall:

      Remove the alias from the file.

## Usage

```shell
tiso [options...]
```

## Options

### Format Type

| Name  | Description                   |
| :---: | :---------------------------- |
| `-b`  | Use basic format              |
| `-e`  | Use extended format (default) |

### Dates Type

| Name  | Description                      |
| :---: | :------------------------------- |
| `-C`  | Display calendar dates (default) |
| `-W`  | Display week dates               |
| `-O`  | Display ordinal dates            |

### Unit

| Name  | Description                  |
| :---: | :--------------------------- |
| `-Y`  | Display in years             |
| `-m`  | Display in months            |
| `-w`  | Display in weeks             |
| `-d`  | Display in days              |
| `-H`  | Display in hours             |
| `-M`  | Display in minutes           |
| `-S`  | Display in seconds (default) |

### Decimal Fraction

|       Name        | Description                                   |
| :---------------: | :-------------------------------------------- |
|   `-p <digits>`   | Specify decimal precision (default: 0)        |
| `-0, -1, ..., -9` | Shortcut for precision                        |
|       `-f`        | Use a dot for the decimal separator (default) |
|       `-c`        | Use a comma for the decimal separator         |

### Time Zone

|    Name     | Description                                                   |
| :---------: | :------------------------------------------------------------ |
|    `-i`     | Do not show time zone (default)                               |
|    `-z`     | Show time zone in minutes                                     |
|    `-Z`     | Show time zone in hours                                       |
|    `-l`     | Do not set time zone to UTC (default)                         |
|    `-u`     | Set time zone to UTC                                          |
|    `-U`     | Set time zone to UTC with 'Z' designator                      |
| `-s <sign>` | Specify the type of minus sign for the time zone (default: -) |

### Others

|      Name      | Description                        |
| :------------: | :--------------------------------- |
|      `-n`      | Suppress new line                  |
|      `-N`      | Do not suppress new line (default) |
| `-D <command>` | Specify a custom date command      |

### Utility

| Name  | Description  |
| :---: | :----------- |
| `-v`  | Show version |
| `-h`  | Show help    |

## Environments

| Name  | Description                                         |
| :---: | :-------------------------------------------------- |
| `TZ`  | Set time zone if the -u or -U flag is not specified |

## Examples

```shell
$ tiso
2012-03-04T12:34:56

$ tiso -b
20120304T123456

$ tiso -W
2012-W09-7T12:34:56

$ tiso -O
2012-064T12:34:56

$ tiso -d
2012-03-04

$ tiso -3
2012-03-04T12:34:56.123

$ tiso -p 10
2012-03-04T12:34:56.1234567890

$ tiso -c3
2012-03-04T12:34:56,123

$ tiso -z
2012-03-04T12:34:56-05:00

$ tiso -Z
2012-03-04T12:34:56-05

$ tiso -u
2012-03-04T17:34:56

$ tiso -U
2012-03-04T17:34:56Z

# U+2012 is MINUS SIGN
$ tiso -s $'\u2012' -z
2012-03-04T12:34:56−05:00

$ tiso -n
2012-03-04T12:34:56$

$ tiso -D 'date -d "1972-12-16"'
1972-12-16T00:00:00
```

## Development

### Test

#### Test Requirements

- [ShellSpec](https://shellspec.info/)
- [GNU Date](https://www.gnu.org/software/coreutils/manual/html_node/date-invocation.html) ([GNU Core Utilities](https://www.gnu.org/software/coreutils/))

```shell
# If `gdate` is in the PATH
shellspec

# If `date` command is GNU Date, e.g. if you are using GNU/Linux
GNU_DATE=date shellspec

# Otherwise
GNU_DATE=path/to/gnu_date shellspec
```

### Lint

#### Lint Requirements

- [ShellCheck](https://www.shellcheck.net/)

```shell
shellcheck **/*.sh bin/*
```
