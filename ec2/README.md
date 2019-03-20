# ec2

Provides simple conrols for AWS EC2 instance.

Prerequisites:

* Installed AWC [CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
* Installed [`jq`](https://stedolan.github.io/jq/) processor
* EC2 instance PEM key saved in `~/.ssh/<instance-name>.pem`

Commands:

* `start` - starts EC2 instance, if not already running
* `ssh` - opens SSH shell to running EC2 instance (with optional local port tunnel)
* `stop` - stops EC2 instance, if running

Note that no actual SSL key is added to the known hosts file for SSH command since the instance's public IP is changing with every restart.

Examples:

``` 
./ec2 -p dev dummy start
```
Starts `dummy` instance using local `dev` AWS profile.

```
./ec2 -p dev -u ubuntu -t 8888 test ssh
```
Opens SSH shell to `dummy` instance for `ubuntu` remote user. Opens tunnel between remote and local port `8888`. Instance's IP is obtained using the local `dev` AWS profile.

```
./ec2 -p dev dummy stop
```
Stops `dummy` instance using local `dev` AWS profile.
