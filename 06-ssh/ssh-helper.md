## About systemd
Systemd is an init system used by most Linux distributions. Its main responsibility is to handle starting other programs and processes. Systemd services are daemons or background processes that are usually started automatically on startup.

## Tips for configuring SSH
For serverside configuration, edit the file `/etc/ssh/sshd_config`.

SSH public keys on the server are stored in the file `~/.ssh/authorized_keys`.

SSH keys on the client side are stored in the directory `~/.ssh/`.

## Some helpful commands
To query status of a systemd service:
`systemctl status <name of service>`

To enable and start a systemd service:
`systemctl enable --now <name of service>`

To connect to the local ssh server:
`ssh kali@localhost`

To generate a new SSH key using a specific algorithm:
`ssh-keygen -t <name of algorithm>`
