# RTMP Relay
Allows you to run a RTMP server in Docker. Using nginx and the nginx RTMP module.

# RTMP Server Config Example
Create file server.rtmp.conf in the config folder with the content:
```
server {
    listen 1935;
    chunk_size 4096;

    application live {
        live on;
        record off;
        meta copy;
    }
}
```

# Setup Routing on Linux
Redirect incoming traffic on port 1935 to local server. Used for capturing PS4 Twitch stream.

```
sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A PREROUTING -p tcp --dport 1935 -j DNAT --to-destination 127.0.0.1:1935
```
