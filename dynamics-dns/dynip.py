#!/usr/bin/env python
#
#  Dynip.py
#
#  Script to keep your public IP address in sync with a dynamic DNS provider
#  This module should be scheduled for regular invocation.
#

import os
import sys
import httplib
import json


def what_is_my_ip():
    '''
    Returns the public IP address as reported by ipinfo.io, exception raised on failure.
    '''
    ip_address=None
    ip_query_url='ipinfo.io'

    connection = httplib.HTTPConnection(ip_query_url)
    connection.request('GET', '/json')
    r1 = connection.getresponse()
    print r1.status, r1.reason
    if r1.status==200:
        data = json.loads(r1.read())
        ip_address = data['ip']

    return ip_address


def get_last_known_ip(cache_file):
    '''
    Returns the last known ip address that we cached on the file system, None otherwise.
    '''
    try:
        with open(cache_file, 'r') as f:
            return f.read().strip()
    except:
        return None


def cache_current_ip(ip_address, cache_file):
    '''
    Caches the specified IP address on the local file system. Returns True on success
    '''
    try:
        with open(cache_file, 'w') as f:
            f.write('{}\n'.format(ip_address))
            return True
    except:
        return False


if __name__ == '__main__':

    # Script to be called when dyndns record needs to be updated
    dns_update_script='./dynip-update.py'

    # local cache file to keep the last known ip address
    cache_file='/var/tmp/dynip.lastknown'

    print 'Querying your IP address...'
    current_ip=what_is_my_ip()
    last_ip=get_last_known_ip(cache_file)

    if current_ip and current_ip != last_ip:
        print 'IP has changed, updating DNS records...'
        rc=os.WEXITSTATUS(os.system('{} {}'.format(dns_update_script, current_ip)))
        print 'DNS upgrade rc={}'.format(rc)
        if rc==0:
            print 'Updating cache...', cache_current_ip(current_ip, cache_file)
        sys.exit(rc)
    else:
        print 'IP is steady, nothing to be done'
        sys.exit(0)
