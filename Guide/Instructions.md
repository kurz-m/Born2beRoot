# Initial setup for Born2beRoot
The commands can be run from the root user. If you are running the commands
from a regular user, you have to use sudo for most of the commands to work.

1. Install sudo on the system.

`apt-get install sudo`

2. Add a group called 'user42'

`groupadd user42`

3. Add 'makurz' to the groups

`usermod -a -G user42,sudo makurz`

> -a stands for append the user to the group<br>
> -G specifies the groups which the user gets added to

4. Install **SSH** if not installed and change port to 4242

- Check **SSH** status: `systemctl status ssh`

```shell
apt-get install ssh
vim /etc/ssh/sshd_config
```

- Remove the `#` on the line with `Port 22` and change it to 4242.
- Furthermore, set 'PermitRootLogin' to `no`

After changing the port number you have to restart the SSH service.
```shell
systemctl restart ssh
```

5. Install/enable `ufw` firewall and allow `Port 4242`

```shell
apt-get install ufw
ufw allow 4242
ufw status
```

6. Setup the network in virtualbox

- Go to the 'Settings' tab and then on 'Network'
- Click on 'Advanced' and then 'Port Forwarding'
- Create a new rule with 'TCP' and 'Host Port' and 'Guest Port', both being set to '4242'

7. Setup the password policy

- Install libpam-pwquality if not already installed `apt-get install libpam-pwquality`.
- Change the file at _/etc/security/pwquality.conf_ according to the subject.
- Make sure to include the following line to the _/etc/pam.d/common-password_.

```
# Words are seperated with tabs
password   requisite   pam_pwquality.so
```

- It takes the changes from _pwquality.conf_ and applies the password policy.
- Change the file _/etc/login.defs_ and change the following.

```
PASS_MAX_DAYS 30
PASS_MIN_DAYS 2
PASS_WARN_AGE 7
```

This changes will only be applied to newly created users. Therefore you have to change it manually for the
already existing user _login42_ and also for _root_.

```shell
# -m for PASS_MIN_DAYS -M for PASS_MAX_DAYS and -W for PASS_WARN_AGE
chage -m 2 -M 30 -W 7 user42
chage -m 2 -M 30 -W 7 root
# Check if rules have been applied.
chage -l user42
chage -l root
```

8. Change the `sudo` usage policy

```shell
visudo
```
```
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
Defaults	logfile="/var/log/sudo/sudo.log"
# Define that input and output should be locked.
Defaults	log_input, log_output
# Requires the user to be logged into a terminal to run the sudo command.
Defaults	requiretty

# User privilege specifications (add your user)
user42  ALL=(ALL:ALL) ALL
```

9. Add some additional packages for general purpose and for the monitoring script

- only net-tools and bc must be installed for the monitoring.sh to work (also works with other tools if you change the script).

```shell
# net-tools for basic networking tools (ifconfig, netstat, etc.)
apt-get install net-tools
# bc for the calculation of an additional script regarding the timing (not mandatory)
apt-get install bc
```

10. Create a file 'monitoring.sh' in /usr/local/bin/ (this can be whereever you want your script to be)

```shell
touch /usr/local/bin/monitoring.sh
# Give execution permissions to the file to run it
chmod +x /usr/local/bin/monitoring.sh
```

Try to create your own script. If you struggle, you can have a look at [this file](./monitoring.sh) and adjust it to your understanding.

11. Define a cronjob to run the monitoring script every 10 minuts

```shell
# Call the crontab function with the -u(ser) 'root' and the -e(dit) flag
crontab -u root -e
```

Add the following line to the end of the file.

```shell
# The cronjob gets 5 inputs
# First is minutes, hour, day (of month), month, and day (of week)
*/10 * * * * /usr/local/bin/monitoring.sh
```

If you want to create an additional script, in order for the script to run every 10th minute after system startup
you can create something similar to [this](./delay.sh) and extend the cronjob accordingly.

```shell
# wait 30 seconds after reboot to run the monitoring.sh script
@reboot sleep 30 && /usr/local/bin/monitoring.sh
# and then add the delay.sh script in front of the monitoring.sh script
*/10 * * * * /usr/local/bin/delay.sh && /usr/local/bin/monitoring.sh
```
