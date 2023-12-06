## To extend the file system of EBS volumes

```shell
# Check whether the volume has a partition. Use the lsblk command.
sudo lsblk

# Extend the partition. Use the growpart command and specify the partition to extend.
sudo growpart /dev/xvda 1

# Extend the file system.
# XFS file system
sudo xfs_growfs -d /
# Ext4 file system
sudo resize2fs /dev/xvda1
```
