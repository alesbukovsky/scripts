# `ecboot.py`

Reboots the entire AWS [ElastiCache](https://aws.amazon.com/elasticache/) cluster. Waits until the cluster becomes available again. 

Prerequisites:

* [Python 3](https://www.python.org/)
* [AWS Python SDK](https://aws.amazon.com/sdk-for-python/) (`boto3`). 

Usage:
```
ecboot.py <name>
```

Options:

* `name`

    AWS ElasticSearch cluster name to reboot.

Example:
```
ecboot.py my-ec-cluster
```
