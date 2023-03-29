# Instructions for Born2beRoot

1. Install sudo on the system.

`apt-get install sudo`

2. Add a group called 'user42'

`groupadd user42`

3. Add 'makurz' to the groups

`usermod -a -G user42,sudo makurz`

> -a stands for append the user to the group
> -G specifies the groups which the user gets added to

4. Install **SSH** if not installed and change port to 4242

```shell
apt-get install ssh
vim /etc/ssh/sshd_config
```

- Remove the `#` on the line with `Port 22` and change it to 4242.
- Furthermore, set 'PermitRootLogin' to `no`

5. Setup the network in virtualbox

- Go to the 'Settings' tab and then on 'network'
- Click on 'Advanced' and then 'Port Forwarding'
- Create a new rule with 'TCP' and 'Host Port' and 'Guest Port' being set to '4242'

6. Change to the user 'makurz'

`su - makurz`
