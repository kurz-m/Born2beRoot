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
- Change the file at _/etc/security/pwquality.conf_ according to the subject.
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

# Resets terminal environment to remove any user variable.
Defaults	env_reset
# Sends a mail of bad sudo password attempts.
Defaults	mail_badpass
# Secure paths for the sudo user.
Defaults	secure_path="/usr/local/sbin:/usr/local/bin:/usr/bin:/sbin:/bin"
# Message because of entering a wrong password.
Defaults	badpass_message="Computer says no."
# Max password tried when using sudo.
Defaults	passwd_tries=3
# Defining a logfile for commands used with sudo.
Defaults	logfile="/var/log/sudo.log"
# Define that input and output should be locked.
Defaults	log_input, log_output
# Requires the user to be logged into a terminal to run the sudo command.
Defaults	requiretty
```

8. Add some additional packages for general purpose and for the monitoring script

- only net-tools must be installed for the monitoring.sh to work.

```shell
# net-tools for basic networking tools (ifconfig, netstat, etc.)
apt-get install net-tools
# git for source control (not mandatory)
apt-get install git
```

9. Create a file 'monitoring.sh' in /usr/local/bin/

```shell
touch /usr/local/bin/monitoring.sh
```

Add the content from [this file](./monitoring.sh) into the one on the VM.
