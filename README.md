# rtmp-relay
Experimental form. Currently only builds nginx with RTMP plugin.

# RTMP Server Config Example
Create file server.rtmp.conf in the config folder with the content:

'''
server {
    listen 1935;
    chunk_size 4096;

    application live {
        live on;
        record off;
        meta copy;
    }
}
'''

# Setup Routing on Linux
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A PREROUTING -d 192.0.0.0/8 -p tcp --dport 1935 -j DNAT --to-destination 192.168.1.100:1935
