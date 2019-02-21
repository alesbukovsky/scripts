# fastai

Manages an EC2 instance for [FastAI](http://course18.fast.ai/ml.html) machine-learning course (somewhat outdated setup instruction are [here](https://forums.fast.ai/t/wiki-thread-lesson-1/6825)).

Requires [`jq`](https://stedolan.github.io/jq/) installed (e.g. via Homebrew).

Two variables need be configured within the script:
* `AWS_PROFILE` - a name of the AWS user profile to use for CLI commands. Expects access and secret key set up in `~/.aws/credentials`.
* `EC2_NAME` - a key name of the EC2 instance to manage.

The following commands are available:
* `start` - starts EC2 instance if not already running.
* `ssh` - opens SSH shell to running EC2 instance. No key is added to the known hosts file (public IP is changing with every restart). A tunnel is created on local `:8888` port for [Jupyter](https://jupyter.org/) web console.
* `stop` - stops EC2 instance if running.

Example:
```
./fastai <start|ssh|stop>
```
