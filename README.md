# Background

[Checkbox](https://checkbox.readthedocs.io/) is a flexible test automation software. It’s the main tool used in Ubuntu Certification program.

prepare-checkbox-sanity is a wrapper to help people prepare the environment for PC sanity with checkbox and run plans easier.

# Install

### by debian package
This package is hosted on [checkbox-dev][], install this packge from [checkbox-dev][] will get all packges under development.
~~~ sh
sudo add-apt-repository ppa:checkbox-dev/ppa
sudo apt-get update
sudo apt-get install prepare-checkbox-sanity
~~~

The packages which verified by my machine pool will be copied to ppa:oem-taipei-bot/checkbox-snapshot.
So, you can get verified packages there.
~~~ sh
sudo add-apt-repository ppa:oem-taipei-bot/checkbox-snapshot
sudo apt-get update
sudo apt-get install prepare-checkbox-sanity
~~~

### by basher
This is for develeper install it from github quickly.
The target machine is assumed installed [basher](https://github.com/basherpm/basher/blob/master/README.md)
~~~ sh
$ basher install alex-tu-cc/prepare-checkbox-sanity
$ basher prepare-checkbox-sanity --init # it will install packages from ppa:oem-taipei-bot/checkbox-snapshot
~~~

Then you can just run any plan under com.canonical.certification:: category, e.g.
~~~ sh
$ checkbox-run-plan pc-sanity-smoke-test -b
~~~



Then you can just run any plan under com.canonical.certification:: category, e.g.
~~~ sh
$ checkbox-run-plan sru -b
~~~

# Usage

## Run a checkbox plan

```
$ checkbox-run-plan --help; # to get full view of help
$ checkbox-cli list; # to get the supported test jobs and plans
$ checkbox-run-plan ${plan}; # to run the plan you want
```

If the target plan need a [extrenal configuration](https://checkbox.readthedocs.io/en/latest/launcher-tutorial.html). It can be introduced by ``$ checkbox-run-plan ${plan} --checkbox-conf ${path of external configuration file}``.

The location of configuration file can also be defined in _/etc/default/prepare-checkbox-sanity.conf_.
```
e.g.
$ cat etc/default/prepare-checkbox-sanity.conf
# save the default configuration in environment paramete.
CHECKBOX_CONF=http://path-to-your-configuration-file/checkbox.conf
```


## A real example on run plan
```
$ checkbox-cli list | grep plan  | grep poweroff | grep auto
        test plan 'com.canonical.certification::power-management-reboot-poweroff-cert-automated'
        test plan 'com.canonical.certification::stress-30-reboot-poweroff-automated'
$ checkbox-run-plan stress-30-reboot-poweroff-automated

$ checkbox-cli list | grep plan  | grep tpm2 | grep auto
# -b is to skip asking for configuration file
$ checkbox-run-plan tpm2.0_3.0.4-automated -b
```

## All usage can also be refered to help:
```sh
$ prepare-checkbox-sanity --help
$ checkbox-run-plan --help
```
## Tips for checkbox

## [side-loading proficders](https://checkbox.readthedocs.io/en/latest/side-loading.html)
### An example to side load plainbox-provider-pc-sanity and your plainbox-provider-checkbox

```
$ prepare-checkbox-sanity --side-load https://git.launchpad.net/plainbox-provider-pc-sanity --side-load https://git.launchpad.net/~alextu/plainbox-provider-checkbox#test-cpu-pc10-by-turbostate
```

## [checkbox remote](https://checkbox.readthedocs.io/en/latest/remote.html)

```
Invocation:
    Slave:
$ checkbox-cli slave
    Master:
$ checkbox-cli master HOST [/PATH/TO/LAUNCHER]
```

check-cli master can be run in a docker instance for convenient:

```
$ git clone https://git.launchpad.net/~hugh712/checkbox-ng
$ cd checkbox-ng && ./setup.py install
$ checkbox-cli master HOST [/PATH/TO/LAUNCHER]
```

## checkbox bootstrap
```
# checkbox-cli list-bootstrapped ${target-plan}
$ checkbox-cli list-bootstrapped com.canonical.certification::client-cert-auto
```

[checkbox-dev]: https://launchpad.net/~checkbox-dev/+archive/ubuntu/ppa
