# Instructions for Born2beRoot
The commands can be run from the root user. If you are running the commands
from a regular user, you have to use sudo for most of the commands to work.

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

- Check **SSH** status: `systemctl status ssh`
- Remove the `#` on the line with `Port 22` and change it to 4242.
- Furthermore, set 'PermitRootLogin' to `no`

5. Install/enable `ufw` firewall and allow `Port 4242`

```shell
apt-get install ufw
ufw allow 4242
ufw status
```

6. Setup the network in virtualbox

- Go to the 'Settings' tab and then on 'network'
- Click on 'Advanced' and then 'Port Forwarding'
- Create a new rule with 'TCP' and 'Host Port' and 'Guest Port' being set to '4242'

6. Setup the password policy

- Install libpam-pwquality if not already `apt-get install libpam-pwquality`.
- Change the file at _/etc/security/pwquality.conf_ according to the [PDF](//).
- Make sure to include the following line to the _/etc/pam.d/common-password_.

`password   requisite   pam_pwquality.so`

- It takes the changes from _pwquality.conf_ and applies the password policy.
- Change the file _/etc/login.defs_ and change the following.

```
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7
```

7. Change the `sudo` usage policy

```shell
sudo visudo

Defaults	env_reset
Defaults	mail_badpass
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/bin:/sbin:/bin"
Defaults	badpass_message="Computer says no."
Defaults	passwd_tries=3
Defaults	logfile="/var/log/sudo.log"
Defaults	log_input, log_output
Defaults	requiretty
```
