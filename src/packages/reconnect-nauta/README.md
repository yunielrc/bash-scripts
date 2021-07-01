# Reconnect nauta

## About

For some reason etecsa closes the wifi nauta session around every 20-45 minutes.
This bot reconnect the session automatically if it was deliberately closed by etecsa.

## Getting Started

### Prerequisites

You need to have sweet-nauta-server running in your machine.
If that is not the case, go to <https://github.com/yunielrc/sweet-nauta-server>
and intall it.

### Installing

Clone this repository

```sh
git clone https://github.com/yunielrc/bash-scripts.git
```

Install reconnect-nauta

```sh
cd bash-scripts/src/packages/reconnect-nauta
chmod +x install
./install
```

Configure reconnect-nauta, modify `SWEET_NAUTA_...` variables if is necessary

```sh
sudo vim /etc/reconnect-nauta.env
```

## Usage

This bot run in background by cron, you don't need todo anything.

To see the logs, run the command below:

```sh
journalctl -f -t reconnect-nauta
```