private-chef Omnibus project
============================
This project creates full-stack platform-specific packages for
`private-chef`!

Installation
------------
You must have a sane Ruby 1.9+ environment with Bundler installed. Ensure all
the required gems are installed:

```shell
$ bundle install --binstubs
```

Usage
-----
### Build

You'll need to create an omnibus.rb file based on the
omnibus.rb.example.rb.  Please grab credentials from teampass.


You create a platform-specific package using the `build project` command:

```shell
$ bin/omnibus build private-chef
```

The platform/architecture type of the package created will match the platform
where the `build project` command is invoked. For example, running this command
on a MacBook Pro will generate a Mac OS X package. After the build completes
packages will be available in the `pkg/` folder.

### Clean

You can clean up all temporary files generated during the build process with
the `clean` command:

```shell
$ bin/omnibus clean private-chef
```

Adding the `--purge` purge option removes __ALL__ files generated during the
build including the project install directory (`/opt/private-chef`) and
the package cache directory (`/var/cache/omnibus/pkg`):

```shell
$ bin/omnibus clean private-chef --purge
```

### Help

Full help for the Omnibus command line interface can be accessed with the
`help` command:

```shell
$ bin/omnibus help
```

Kitchen-based Build Environment
-------------------------------
Every Omnibus project ships will a project-specific
[Berksfile](http://berkshelf.com/) that will allow you to build your omnibus projects on all of the projects listed
in the `.kitchen.yml`. You can add/remove additional platforms as needed by
changing the list found in the `.kitchen.yml` `platforms` YAML stanza.

This build environment is designed to get you up-and-running quickly. However,
there is nothing that restricts you to building on other platforms. Simply use
the [omnibus cookbook](https://github.com/opscode-cookbooks/omnibus) to setup
your desired platform and execute the build steps listed above.

The default build environment requires Test Kitchen and VirtualBox for local
development. Test Kitchen also exposes the ability to provision instances using
various cloud providers like AWS, DigitalOcean, or OpenStack. For more
information, please see the [Test Kitchen documentation](http://kitchen.ci).

Once you have tweaked your `.kitchen.yml` (or `.kitchen.local.yml`) to your
liking, you can bring up an individual build environment using the `kitchen`
command.

**NOTE:** Test Kitchen shoud be installed external to the local Ruby bundle.
Please either use ChefDK or install the latest test-kitchen from Rubygems.

```shell
$ kitchen converge ubuntu-1204
```

Test Kitchen uses a regex syntax to match on plaforms, so for example ubuntu 10.04
will be specificed as ubuntu-1004, or even just ubuntu-10, if 10.04 is the
only 10 series specified in the `.kitchen.yml`.

If you skipped down to this section without reading the rest of the
README, note that you'll need to copy omnibus.rb.example to omnibus.rb
in the opscode-omnibus directory (either before running kichen or from
the opscode-omnibus directory once logged into the VM, which is the
same directory mounted into it).

Then login to the instance and build the project as described in the Usage
section:

```shell
$ kitchen login ubuntu-1204
[vagrant@ubuntu...] $ cd opscode-omnibus
[vagrant@ubuntu...] $ bundle install --binstubs
[vagrant@ubuntu...] $ ...
[vagrant@ubuntu...] $ bin/omnibus build private-chef
```
or if you prefer not to use binstubs and to use bundle exec instead:

```shell
$ kitchen login ubuntu-1204
[vagrant@ubuntu...] $ cd opscode-omnibus
[vagrant@ubuntu...] $ bundle install
[vagrant@ubuntu...] $ ...
[vagrant@ubuntu...] $ bundle exec omnibus build private-chef
```

For a complete list of all commands and platforms, run `kitchen list` or
`kitchen help`.
