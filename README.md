# Debian Workstation

## Summary

Automated install and configuration management of a Debian workstation. Supports both CLI-only (terminal) and Desktop
environments.

The Debian OS install is automated via a Debian `preseed.cfg` file, which _preseeds_ the answers to _most_ of the
prompts in the Debian OS installer. Some installer prompts were intentionally left unanswered (e.g. password,
partitioning, etc). See the [OS Install Preseed](#os-install-preseed) section for instructions how to use it.

The workstation configuration is applied and managed by Ansible. You do not need to have Ansible installed. The Ansible
version, runtime, and dependencies are all managed for you in a Python virtual environment using the Python package
manager [Poetry](https://python-poetry.org/).

## Install

Run the following bootstrap script. It which will install the required dependencies (`git`, `pipx`, `poetry`) and then
it will clone the repo to `~/build/debian-workstation`.

```console
source <(wget -O - https://raw.githubusercontent.com/decoyjoe/debian-workstation/main/bootstrap.sh) && bootstrap
```

Then run the `./init.sh` script which will initialize the repo so it's ready for use:

```console
./init.sh
```

## Usage

Run the `install.sh` script which will execute Ansible to apply the configuration:

```console
./install.sh
```

## OS Install Preseed

If you'd like to use the [`preseed.cfg`](preseed.cfg) file to automate the Debian OS installer, you first need to read
through the file and confirm it suits your needs. The preseed answers were selected based on my personal preferences and
may not be suitable for you!

### Usage

The `preseed.cfg` file can be provided to the Debian installer as a file path or URL. It's easiest to provide it as a
URL directly from a source control repository, such as this one.

1. Boot the Debian installer.
1. Choose `Advaned options...`
1. Choose `Automated install`.
1. Enter the URL to the preseed file:

    ```console
    https://raw.githubusercontent.com/decoyjoe/debian-workstation/main/preseed.cfg
    ```

This preseed file answers every installer question, except for:

- The user password.
- The disk to partition for the OS install (if more than one disk is present).
  - Pay attention to the disk device path. You'll need it for the GRUB target disk install prompt!

### Desktop environment

The preseed file also only selects the "standard" task for install, which only includes the base system utilities; no
desktop environment or SSH server is included. Once the system reboots you'll see only a plain CLI console.

To install a desktop environment you'll need to login and install one of the Debian desktop environment task packages.

For example, to install the KDE Plasma desktop environment:

```console
sudo apt install task-kde-desktop
```

See the [DesktopEnvironment - Debian Wiki](https://wiki.debian.org/DesktopEnvironment) for the full list of available desktop environment tasks.
