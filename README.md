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

## scripts

These are in `scripts/` and based on:

* https://github.com/pristineio/webrtc-build-scripts

They are dumped in `/opt/webrtc/scipts/` by `ansible` when provisioning so if
e.g. you provisioned a `vagrant` vm you can do: 

```bash
$ vagrant ssh
vagrant@vagrant-ubuntu-trusty-64$ cd /opt/webrtc
vagrant@vagrant-ubuntu-trusty-64$ WEBRTC_OS=linux WEBRTC_ARCH=armv7hf WEBRTC_BUILD=debug ./scripts/build
```

but you'll typically just use `make`.

### make

The orchestration for building, packaging and publishing using:

* [depot_tools](http://www.chromium.org/developers/how-tos/depottools) and
* `scripts/`

is done using a :neckbeard: `make` file. Its copied to `/opt/webrtc/Makefile` by `ansible`
when provisioning. So e.g. to do everything:

```bash
$ make clean
$ make all
...
```

or step manually for an explicit target, e.g. `linux_arm_debug`, do:

```bash
$ make build_linux_arm_debug
...
$ make pkg_linux_arm_debug
...
$ make pub_linux_arm_debug
...
```
