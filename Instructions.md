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

7. Setup the password policy

- Install libpam-pwquality if not already `apt-get install libpam-pwquality`.
- Change the file at _/etc/security/pwquality.conf_ according to the subject.
- Make sure to include the following line to the _/etc/pam.d/common-password_.

```
# Words are spaces with tabs
password   requisite   pam_pwquality.so
```

- It takes the changes from _pwquality.conf_ and applies the password policy.
- Change the file _/etc/login.defs_ and change the following.

```
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7
```

Because this changes will only applied to new created users. Therefore you have to change it manually.

```shell
# -m for PASS_MIN_DAYS -M for PASS_MAX_DAYS and -W for PASS_WARN_AGE
chage -m 2 -M 30 -W 7 user42
# Check if rules have been applied.
chage -l user42
```


8. Change the `sudo` usage policy

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

# User privilege specifications (add your user)
user42  ALL=(ALL:ALL) ALL

# Allow member of group sudo to execute any command (add root for monitoring.sh)
user42  ALL=(root) NOPASSWD: /usr/local/bin/monitoring.sh
```

9. Add some additional packages for general purpose and for the monitoring script

- only net-tools must be installed for the monitoring.sh to work.

```shell
# net-tools for basic networking tools (ifconfig, netstat, etc.)
apt-get install net-tools
# git for source control (not mandatory)
apt-get install git
```

10. Create a file 'monitoring.sh' in /usr/local/bin/

```shell
touch /usr/local/bin/monitoring.sh
# Give all permissions to the file to run it
chmod 777 /usr/local/bin/monitoring.sh
```

Add the content from [this file](./monitoring.sh) into the one on the VM.

11. Define a cronjob to run the monitoring script every 10 minuts

```shell
# Call the crontab function with the -u(ser) 'root' and the -e(dit) flag
crontab -u root -e
```

Add the following line to the end of the file.

```shell
# The cronjob gets 5 inputs
# First is minutes, hour, day (month), month, and day (week)
*/10 * * * * /usr/local/bin/monitoring.sh
```