#!/usr/bin/env python
#
# dynip-update.py
#
# Contacts dyndns, noip, or similar, to update your current public IP address.
# Invoke this script with your IP as the first argument.
# Returns 0 if updated records, nonzero on error
#

import sys

if __name__ == '__main__':
    
    if len(sys.argv) < 2:
        print 'Please provide your IP address'
        sys.exit(1)

    # TODO: do it :-D
    ip_address = sys.argv[1]
    print 'dynip-update.py to update IP:', ip_address
    sys.exit(0)
