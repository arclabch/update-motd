# update-motd

`update-motd` is a small utility to generate a `motd` file with useful information.

`update-motd` has been tested on FreeBSD, OpenBSD, NetBSD, Solaris and Debian GNU/Linux. It should run on other Unix-like systems as well.

However, it will **NOT** run on Ubuntu, as Ubuntu already has a similar script, but the scripts (`XX-*`) will run on Ubuntu with a bit of adaptation.

## Usage

Simply call its name from the command line.

As `root`, it will not produce any output but update your `/etc/motd` file. As another user, it will generate an equivalent motd and print it to screen.

As such, it is possible to replace the printing of `/etc/motd` on login by the running of `update-motd` for a real time result.

By default, a crontab file will be installed during installation, if possible, to run `update-motd` at boot and then once per hour. Other installation methods are left to the creativity of the sysadmin.

## Installation

On non-GNU systems such as FreeBSD and OpenBSD, you require [GNU Make](https://www.gnu.org/software/make/). For those, replace `make` by `gmake` in the commands below.

**Get it:**

```sh
$ git clone https://github.com/arclabch/update-motd
```

**Compile it:**

Prepare it:

```sh
$ cd update-motd
$ git checkout release/1.0.0 
$ make
```

**Install it (as root):**

```sh
$ sudo make install
```

**Update it (as root):**

If you already have an earlier version of update-motd installed, simply run

```sh
$ sudo make update
```

to update it without overwritting your existing configuration.


## What's New

**1.0.0**

- Initial release.

## License

MIT. See `LICENSE` file.