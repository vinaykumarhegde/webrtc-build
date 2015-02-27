# webrtc-build

Automation for:

- building
- packaging

[Google's implementation](https://code.google.com/p/webrtc/) of WebRTC.

## references  

This is based on:

* http://www.webrtc.org/native-code/development
* https://github.com/pristineio/webrtc-build-scripts

## dependencies

Controller needs:

* [ansible](http://docs.ansible.com/intro_installation.html#installing-the-control-machine)
* [vagrant](https://docs.vagrantup.com/v2/installation/)
* [python-vagrant](https://github.com/todddeluca/python-vagrant#install-from-pypipythonorg) and
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
```

and, **much** later once provisioning is done, start building out of `vagrant@~/webrtc`:

```bash
$ cd ..
$ vagrant ssh
vagrant@vagrant-ubuntu-trusty-64$
```

## scripts

Helpers for doing minor things the WebRTC build system doesn't are in
`scripts/` and based on:

* https://github.com/pristineio/webrtc-build-scripts

They are dumped in `~/webrtc/scipts/` by `ansible` when provisioning, so if
e.g. you provisioned a `vagrant` vm you can do: 

```bash
$ vagrant ssh
vagrant@vagrant-ubuntu-trusty-64$ cd ~/webrtc
vagrant@vagrant-ubuntu-trusty-64$ WEBRTC_PROFILE=linux_armv7hf WEBRTC_BUILD=debug ./scripts/build
```

but you'll typically just use `make`.

### make

Building and packaging using:

* [depot_tools](http://www.chromium.org/developers/how-tos/depottools) and
* `scripts/`

is done using a :neckbeard: `make` file. Its copied to `~/webrtc/Makefile` by `ansible`
when provisioning so e.g. to do everything:

```bash
$ make clean
$ make all
...
```

or for a specific target, e.g. `linux_armhf_release`, do:

```bash
$ make linux_armhf_release
...
```

with the resulting packages output to `build/`.
