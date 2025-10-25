# Vagrant

* How to Install
* How to Use
* Useful Commands and Info

## How to Install
Install VirtualBox: [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)  
Install Vagrant: [https://developer.hashicorp.com/vagrant/install](https://developer.hashicorp.com/vagrant/install)

## How to Use
All the contents of this "VM" folder will be available on the VM.  
Navigate to the proper folder in your terminal and run:  
```bash
vagrant up
```
## Useful Commands and Info
Shutdown the VM:
```bash
vagrant halt
```
"Full" cleanup
```bash
vagrant destroy
```
### Default login:
 _vagrant:vagrant_

Run provision scripts
```bash
vagrant provision
```