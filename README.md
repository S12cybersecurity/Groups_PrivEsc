# Linux Groups Privilege Escalation

**What is?**
This tool is a script programmed in Bash that automates the escalation of privileges according to the groups in which the user in use is assigned.
It can be very useful when escalating privileges in CTF, but it will work in any Linux environment.

**How's work?**

- **LXD**:
The first group that this script exploits is LXD, if the user is in the LXD group it will automatically create a container in which you will have all the HOST filesystem inside the /mnt/root folder.

For this group you need to upload a file called:
alpine-v3.13-x86_64-20210218_0139.tar.gz

Which is also in this repository

![image](https://user-images.githubusercontent.com/79543461/187026513-e9e2fa85-087f-4e57-a3cb-6e117f078a3b.png)

- **Docker**:
The second group that exploits this script is the Docker group, this one is even easier to exploit because you don't need to upload any files.

This group also creates a container although in this case it is a docker container, it gives you a reverse shell with root permissions after getting SUID permissions to the /bin/bash file.

Even so, in case this has not worked, it gives you a shell in the created container where if you go to the /mnt path you can find all the files on the host machine and read and write

![image](https://user-images.githubusercontent.com/79543461/187026739-363ea5df-0e19-4a6f-bb2f-a642c98ffa01.png)

- **Disk**
The third group is a little different from the previous two, this group called Disk is a group that depends on how the server is configured, you can read files and partitions that normally a normal user could not read.

In this case, what my script does is list the files with which the disk group can interact.

- **Shadow**

The fourth group that my Script exploits is the Shadow group, as its name indicates this group allows you to read the /etc/shadow file, my script simply runs a cat on this file so that you can try to crack the hashes inside it offline of the file.

- **MICROKUBS**

The last group that exploits my Script is MICROKUBS, this group is very similar to the first two, but with a Kubernetes theme.

This script can fail because there is a file called pod.yaml that has given me problems on different machines, but on most it works.

For more information visit this good article:

https://prophaze.com/cve/privilege-escalation-vulnerability-in-microk8s-allows-a-low-privilege-user-with-local-access-to-obtain-root-access-to-the-host-by-provisioning-a-privileged-container-fixed-in-microk8s-1-15-3/
