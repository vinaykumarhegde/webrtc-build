# webrtc-build [![Build Status](https://travis-ci.org/mayfieldrobotics/webrtc-build.svg?branch=refactor)](https://travis-ci.org/mayfieldrobotics/webrtc-build)

Automation for:

- building
- packaging

[Google's implementation](https://code.google.com/p/webrtc/) of WebRTC.

## references  

This is based on:

* http://www.webrtc.org/native-code/development
* https://github.com/pristineio/webrtc-build-scripts

## quickstart

If you just want packages add this apt repo:

```bash
$ curl "http://apt-tm8ji0.c2x.io/1D33909E.asc" | sudo apt-key add -
$ sudo sh -c 'echo "deb http://apt-tm8ji0.c2x.io/ trusty unstable" > /etc/apt/sources.list.d/tmp.apt_tm8ji0_c2x_io.list'
```

and install them:

```bash
$ sudo apt-get install libjinglea4ef2ce libjinglea4ef2ce-dev libjinglea4ef2ce-dbg libjinglea4ef2ce-src
```

then maybe [test them](##test). If you want to build a particular *version*:

* get commit hash from the [webrtc project](https://chromium.googlesource.com/external/webrtc) (e.g. `a4ef2ce29de0c68b869f8d66276bc5acba54cc79`).
* change `webrtc_dev_rev` in `provision/roles/webrtc_dev/defaults/main.yml`
  to that commit hash (e.g. `a4ef2ce29de0c68b869f8d66276bc5acba54cc79`)
* make sure [it still builds](##build)!

if so tag it w/ the short commit hash:

```bash
~/code/webrtc-build$ git commit -am a4ef2ce"
~/code/webrtc-build$ git tag -a a4ef2ce -m a4ef2ce"
~/code/webrtc-build$ git push --tags
```

and [travis](https://travis-ci.org/mayfieldrobotics/webrtc-build) will build
and publish packages for it to apt repo.

## dependencies

You'll need [ansible](http://docs.ansible.com/intro_installation.html#installing-the-control-machine)
so e.g.:

```bash
$ sudo apt-get install ansible
```

and optionally:

* [Vagrant/Virtualbox](https://www.vagrantup.com/docs/getting-started/) if you
plan on [building things locally](###local).
* [aws-cli](https://aws.amazon.com/cli/) if you plan on [building things in aws](###remote).

## build

Get it:

```bash
~code$ git clone git@github.com:mayfieldrobotics/webrtc-build.git
~code$ cd webrtc-build
```

and then choose one of ...

### local

Only do this if you have a very fast internet connection. Provision a workspace
in a local VM using `vagrant`:

```bash
~/code/webrtc-build$ vagrant up
```

and **much** later once provisioning is done do:

```bash
~/code/webrtc-build$ vagrant ssh
vagrant@vagrant-ubuntu-trusty-64$ cd /opt/webrtc
vagrant@vagrant-ubuntu-trusty-64$ WEBRTC_PROFILE=linux_x86_64 WEBRTC_BUILD_TYPE=Debug ./scripts/build
...
vagrant@vagrant-ubuntu-trusty-64$ ./scripts/package
...
```

which gives you:

```bash
vagrant@vagrant-ubuntu-trusty-64$ ls -m1 out/*deb
out/libjinglea4ef2ce_1a4ef2ce-1_amd64.deb
out/libjinglea4ef2ce-dbg_1a4ef2ce-1_amd64.deb
out/libjinglea4ef2ce-dev_1a4ef2ce-1_amd64.deb
out/libjinglea4ef2ce-src_1a4ef2ce-1_all.deb
```

### remote

We'll use AWS here but you should be able to use other infras. What follows is
~ what `.travis.yml` does.

Create an instance:

```bash
/code/webrtc-build$ aws ec2 run-instances \
--image-id ami-06116566 \
--security-group-ids sg-be74c7da \
--instance-type c4.xlarge \
--subnet-id subnet-5ac2623f \
--block-device-mappings "[{\"DeviceName\": \"/dev/sdb\",\"Ebs\":{\"VolumeSize\":40,\"DeleteOnTermination\":true}}]" \
--count 1 \
--key-name ai-gazelle
{
    ...
                "InstanceId": "i-d38a4e44", 
    ...
}
```

or if you have a baseline image (e.g. ``) do:

```bash
/code/webrtc-build $ aws ec2 run-instances \
--image-id ami-109ce770 \
--security-group-ids sg-be74c7da \
--instance-type c4.xlarge \
--subnet-id subnet-5ac2623f \
--count 1
{
    ...
                "InstanceId": "i-d38a4e44", 
    ...
}
```

get it's public address:

```bash
/code/webrtc-build$ aws ec2 describe-instances \
--instance-ids i-d38a4e44 \
--query "Reservations[*].Instances[0].{PublicIpAddress:PublicIpAddress}"
[
    {
        "PublicIpAddress": "52.53.221.237"
    }
]
```

and provision it as a webrtc builder:

```bash
/code/webrtc-build$ cd provision
/code/webrtc-build/provision$ ansible-playbook -i "52.53.221.237," -u ubuntu remote.yml
```

Once provisioning is done [create an image](http://docs.aws.amazon.com/cli/latest/reference/ec2/create-image.html):

```bash
/code/webrtc-build$ aws ec2 create-image \
--instance-id i-d38a4e44 \
--name webrtc-build-a4ef2ce \
--description "webrtc-build version a4ef2ce" \
--block-device-mappings "[{\"DeviceName\": \"/dev/sdb\",\"Ebs\":{\"VolumeSize\":40,\"DeleteOnTermination\":true}}]"
{
    "ImageId": "ami-109ce770"
}
/code/webrtc-build$ aws ec2 create-tags \
--resource ami-109ce770 \
--tags "Key=webrtc-build,Value=a4ef2ce"
```

which you can use later when creating builder instances. Finally build and
package:

```bash
~/code/webrtc-build$ ssh ubuntu@54.153.86.252
ubuntu@ip-172-31-27-38:~/$ cd /opt/webrtc
ubuntu@ip-172-31-27-38:/opt/webrtc$ cd /opt/webrtc
ubuntu@ip-172-31-27-38:/opt/webrtc$ WEBRTC_PROFILE=linux_x86_64 WEBRTC_BUILD_TYPE=Debug; ./scripts/build
...
ubuntu@ip-172-31-27-38:/opt/webrtc$ ./scripts/package
...
```

which gives you:

```bash
ubuntu@ip-172-31-27-38:/opt/webrtc$ ls -m1 out/*deb
out/libjinglea4ef2ce_1a4ef2ce-1_amd64.deb
out/libjinglea4ef2ce-dbg_1a4ef2ce-1_amd64.deb
out/libjinglea4ef2ce-dev_1a4ef2ce-1_amd64.deb
out/libjinglea4ef2ce-src_1a4ef2ce-1_all.deb
```

## test

To test built packages install them, e.g.:

```bash
~/code/webrtc-build$ scp ubuntu@54.153.86.252:/opt/webrtc/out/*a4ef2ce*.deb ~/Downloads/
~/code/webrtc-build$ sudo dpkg -i ~/Downloads/libjinglea4ef2ce*$(dpkg --print-architecture).deb
~/code/webrtc-build$ sudo apt-get install -f -y
```

then build test executables:

```bash
~/code/webrtc-build$ cd test
~/code/webrtc-build/test$ LIBJINGLE_VER=a4ef2ce make all
```

and `gdb` them to verify you have debug info and source, e.g.:

```bash
~/code/webrtc-build/test$ gdb test-static
...
(gdb) break webrtc::CreatePeerConnectionFactory
Breakpoint 1 at 0x423df6: webrtc::CreatePeerConnectionFactory. (2 locations)
(gdb) run
...
Breakpoint 1, webrtc::CreatePeerConnectionFactory (worker_thread=0x130d010, signaling_thread=0x130d770, default_adm=0x0, encoder_factory=0x0, decoder_factory=0x0)
    at ../../../talk/app/webrtc/peerconnectionfactory.cc:77
77        rtc::scoped_refptr<PeerConnectionFactory> pc_factory(
(gdb) l
72          rtc::Thread* worker_thread,
73          rtc::Thread* signaling_thread,
74          AudioDeviceModule* default_adm,
75          cricket::WebRtcVideoEncoderFactory* encoder_factory,
76          cricket::WebRtcVideoDecoderFactory* decoder_factory) {
77        rtc::scoped_refptr<PeerConnectionFactory> pc_factory(
78            new rtc::RefCountedObject<PeerConnectionFactory>(worker_thread,
79                                                             signaling_thread,
80                                                             default_adm,
81                                                             encoder_factory,
```

