# Description

This is content prepared for an analysis of a bug in the Volume Shadow Copy driver on Windows 11. The vhd's are small 1 GB disks with an NTFS volume containing a number of shadow copies as indicated in the file name. The powershell script will simply enter a loop and mount and dismount a vhd until the VscCount does not match. This is very crude but the only purpose of the script is to eventually trigger a bug in volsnap.sys version 10.0.22621.1. The two xml's are sample exports from the event log of the errors being logged. Check out the analysis for the details: https://plainbinary.blogspot.com/2023/06/walk-through-of-bug-in-volume-shadow.html.