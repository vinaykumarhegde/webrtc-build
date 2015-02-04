# webrtc-build

Automation for:

- building
- packaging
- publishing

[Google's implementation](https://code.google.com/p/webrtc/) of WebRTC.

## references  

This is based on:

* http://www.webrtc.org/native-code/development
* https://github.com/pristineio/webrtc-build-scripts
* http://unix.stackexchange.com/a/177985

## dependencies

Controller needs:

* [ansible](http://docs.ansible.com/intro_installation.html#installing-the-control-machine)
* [vagrant](https://docs.vagrantup.com/v2/installation/) and
* [python-vagrant](https://github.com/todddeluca/python-vagrant#install-from-pypipythonorg)
* [netaddr](https://pypi.python.org/pypi/netaddr)

so e.g. get them like:

```bash
$ sudo pip install ansible python-vagrant netaddr
$ cd tmp && { curl -O "https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.2_x86_64.deb"; cd -; }
$ sudo dpkg -i /tmp/vagrant_1.7.2_x86_64.deb
```

## quickstart

Get it:

```bash
$ git clone git@github.com:ixirobot/webrtc-build.git
$ cd webrtc-build
```

spawn a vm using `vagrant`:

```bash
$ vagrant up
...
```

then configure it using `ansible`:

```bash
$ cd ../provision
$ ansible-playbook site.yml -i inventories/vagrant
...
```

and start building out of `vagrant@/opt/webrtc`:

```bash
$ cd ..
$ vagrant ssh
vagrant@vagrant-ubuntu-trusty-64$ cd /opt/webrtc
```

## provision

We're using `ansible` to configure machines so e.g. to provision a vagrant
managed vm:

```bash
$ cd provision/
$ ansible-playbook site.yml -i inventories/vagrant
```

## build

Scripts for building are in `scripts/` and based on:

* https://github.com/pristineio/webrtc-build-scripts

They are dumped in `/opt/webrtc/` by `provision` so if e.g. you provisioned a
vagrant vm you can do: 

```bash
$ vagrant ssh
vagrant@vagrant-ubuntu-trusty-64$ cd /opt/webrtc
vagrant@vagrant-ubuntu-trusty-64$ WEBRTC_OS=linux WEBRTC_ARCH=armhf WEBRTC_BUILD=debug ./scripts/build
```

### linux

```bash
$ WEBRTC_OS=linux WEBRTC_ARCH=x86_64 WEBRTC_BUILD=debug ./scripts/build
...
$ ls out/linux_x86_64/Debug/
...
```

### android

**TODO**

### osx

**TODO**

## package

Some build artifacts need to be packaged (e.g. native libs):

### linux-dev deb

```bash
$ WEBRTC_BUILD=Debug ./pkg linux-x86_64
...
$ ls out/linux-x86_64/debug/
```

## publish

And to publish build and package artifacts:

### linux-dev deb

```bash
$ WEBRTC_BUILD=Debug ./pub linux-x86_64
```
