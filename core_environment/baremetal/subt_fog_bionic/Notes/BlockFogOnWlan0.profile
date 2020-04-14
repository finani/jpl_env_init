[fwBasic]
status = enabled
incoming = allow
outgoing = allow
routed = disabled

[Rule0]
ufw_rule = 111 on wlan0 DENY IN Anywhere
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port sunrpc
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = sunrpc
iface = wlan0
routed = 
logging = 

[Rule1]
ufw_rule = 21/tcp on wlan0 DENY IN Anywhere
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port ftp
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = ftp
iface = wlan0
routed = 
logging = 

[Rule2]
ufw_rule = 2049 on wlan0 DENY IN Anywhere
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port nfs
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = nfs
iface = wlan0
routed = 
logging = 

[Rule3]
ufw_rule = 67 on wlan0 DENY IN Anywhere
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port bootps
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = bootps
iface = wlan0
routed = 
logging = 

[Rule4]
ufw_rule = 68 on wlan0 DENY IN Anywhere
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port bootpc
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = bootpc
iface = wlan0
routed = 
logging = 

[Rule5]
ufw_rule = 69/udp on wlan0 DENY IN Anywhere
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port tftp
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = tftp
iface = wlan0
routed = 
logging = 

[Rule6]
ufw_rule = 631 on wlan0 DENY IN Anywhere
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port ipp
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = ipp
iface = wlan0
routed = 
logging = 

[Rule7]
ufw_rule = 657 on wlan0 DENY IN Anywhere
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port 657
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 657
iface = wlan0
routed = 
logging = 

[Rule8]
ufw_rule = 111 (v6) on wlan0 DENY IN Anywhere (v6)
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port sunrpc
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = sunrpc
iface = wlan0
routed = 
logging = 

[Rule9]
ufw_rule = 21/tcp (v6) on wlan0 DENY IN Anywhere (v6)
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port ftp
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = ftp
iface = wlan0
routed = 
logging = 

[Rule10]
ufw_rule = 2049 (v6) on wlan0 DENY IN Anywhere (v6)
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port nfs
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = nfs
iface = wlan0
routed = 
logging = 

[Rule11]
ufw_rule = 67 (v6) on wlan0 DENY IN Anywhere (v6)
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port bootps
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = bootps
iface = wlan0
routed = 
logging = 

[Rule12]
ufw_rule = 68 (v6) on wlan0 DENY IN Anywhere (v6)
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port bootpc
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = bootpc
iface = wlan0
routed = 
logging = 

[Rule13]
ufw_rule = 69/udp (v6) on wlan0 DENY IN Anywhere (v6)
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port tftp
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = tftp
iface = wlan0
routed = 
logging = 

[Rule14]
ufw_rule = 631 (v6) on wlan0 DENY IN Anywhere (v6)
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port ipp
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = ipp
iface = wlan0
routed = 
logging = 

[Rule15]
ufw_rule = 657 (v6) on wlan0 DENY IN Anywhere (v6)
description = 
command = /usr/sbin/ufw deny in on wlan0 from any to any port 657
policy = deny
direction = in
protocol = 
from_ip = 
from_port = 
to_ip = 
to_port = 657
iface = wlan0
routed = 
logging = 

