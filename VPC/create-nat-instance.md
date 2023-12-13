## Create a NAT AMI

## Launch an EC2 instance running Amazon Linux
## Install Iptables Packages
```bash
sudo yum install iptables-services -y
sudo systemctl enable iptables
sudo systemctl start iptables
```

##  Enable IP forwarding
```bash
# /etc/sysctl.d/custom-ip-forwarding.conf
net.ipv4.ip_forward=1
```

```bash
sudo sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf
```

```bash
netstat -i
```

## Configure NAT
```bash
sudo /sbin/iptables -t nat -A POSTROUTING -o <interfact_name> -j MASQUERADE
sudo /sbin/iptables -F FORWARD
sudo service iptables save
```

## Disable source/destination checks for the NAT instance 
