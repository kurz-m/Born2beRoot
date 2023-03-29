# Instructions for Born2beRoot

1. Install sudo on the system.

`apt-get install sudo`

2. Add a group called 'user42'

`groupadd user42`

3. Add 'makurz' to the groups

`usermod -a -G user42,sudo makurz`

> -a stands for append the user to the group
> -G specifies the groups which the user gets added to

4. Change to the user 'makurz'

`su - makurz`
