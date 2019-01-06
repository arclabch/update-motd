# update-motd

`update-motd` is a small utility to generate a `motd` file with useful information.

`update-motd` has been tested on FreeBSD, OpenBSD, NetBSD, Solaris and Debian GNU/Linux. It should run on other Unix-like systems as well.

However, it will **NOT** run on Ubuntu, as Ubuntu already has a similar script, but the scripts (`XX-*`) will run on Ubuntu with a bit of adaptation.

## Sample default output

```
                         ____              __
                        / __/___  ____    / /_  ____ ______
                       / /_/ __ \/ __ \  / __ \/ __ `/ ___/
                      / __/ /_/ / /_/ / / /_/ / /_/ / /
                     /_/  \____/\____(_)_.___/\__,_/_/

LOCALHOST ······································································
Hostname: sample.server.domain.tld
 Address: 192.168.1.42 (vmx0)
  System: FreeBSD 12.0-RELEASE (amd64 GENERIC)

USEFUL INFORMATION ·····························································
This is the default information.txt file. Replace this with useful content, such
as information about the role of this system or usual maintenance commands, or
remove this file entirely to disable this section.

SYSTEM CHANGELOG ·······························································
2019-01-04T10:52  lr  Setup of the new motd system; installation of changelog.

DISCLAIMER ·····································································
By accessing this system, your actions may be intercepted, monitored, recorded,
copied, audited, inspected, and disclosed to third parties. Unauthorized or
improper use of this system will result in civil and criminal penalties and/or
administrative or disciplinary action, as appropriate. By continuing to use
this system you indicate your awareness of and consent to these terms and
conditions of use.

                                        motd refreshed on 2019-01-06 at 21:04:48
```

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