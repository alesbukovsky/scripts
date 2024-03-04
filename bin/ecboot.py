#!/usr/bin/env python3
import boto3
import sys

client = boto3.client('elasticache')

# search for the cache cluster
print('Looking for cache cluster')
resp = client.describe_cache_clusters(
    CacheClusterId=sys.argv[1],
    ShowCacheNodeInfo=True
)
if (len(resp['CacheClusters']) != 1):
    raise Exception('One and only one cluster expected for given id')

# zero in
cluster = resp['CacheClusters'][0]
print('Cache cluster [%s] found with %s node(s)' % (cluster['CacheClusterId'], cluster['NumCacheNodes']))

# reboot all cluster nodes
print('Requesting cache cluster reboot')
resp = client.reboot_cache_cluster(
    CacheClusterId=cluster['CacheClusterId'],
    CacheNodeIdsToReboot=[node['CacheNodeId'] for node in cluster['CacheNodes']]
)

# wait for cluster to become available again
print('Waiting for cache cluster to become available')
waiter = client.get_waiter('cache_cluster_available')
waiter.wait(
    CacheClusterId=cluster['CacheClusterId']
)
print('Cache cluster [%s] rebooted' % cluster['CacheClusterId'])
