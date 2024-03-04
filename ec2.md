# `ec2.sh`

Provides rudimentary controls for AWS EC2 instance.

Prerequisites:

* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* [`jq`](https://stedolan.github.io/jq/) JSON processor
* EC2 instance PEM key saved in `~/.ssh/<instance-name>.pem`

Usage:
```
ec2.sh [-p <profile>] [-u <user>] [-t <port>] [-h] <name> <command>
```

Options:

* `-h`
        
    Show usage description.

* `-p <profile>`

    Local AWS profile name to use.

* `-u <user>`

    Remote EC2 user. Only For `ssh` command.

* `-t <port>`

    Local port number for the SSH tunnel. Only for `ssh` command.

* `name`

    AWS EC2 instance name.

* `command`   

    Action to take with the AWS EC2 instance:
  
    * `start`: starts the instance if not already running
    * `ssh`: opens SSH shell to the running instance
    * `stop`: stops the instance if running

Note that no actual SSL key is added to the known hosts file for SSH command since the instance's public IP is changing with every restart.

Examples:

``` 
ec2.sh -p dev dummy start
```
Starts `dummy` instance using local `dev` AWS profile.

```
ec2.sh -p dev -u ubuntu -t 8888 test ssh
```
Opens SSH shell to `dummy` instance for `ubuntu` remote user. Opens tunnel between remote and local port `8888`. Instance's IP is obtained using the local `dev` AWS profile.

```
ec2.sh -p dev dummy stop
```
Stops `dummy` instance using local `dev` AWS profile.
