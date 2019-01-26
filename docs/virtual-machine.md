# Installing Linux for Windows Systems without WSL
For **any Version of Windows older than Windows 10 Fall Creator's Update**, which is defined as less than **Build 16215** you cannot use Windows Subsystem for Linux, so you will need to install a VM. This means if you're running Windows 8.1 you will also need to follow this guide. If you're using anything older than Windows 7, you're gonna have a bad time. 

## Minimum System Requirements
- 4+ cores
- 8gb+ Memory 
- 30gb available disk space

## Download Requirements

### VirtualBox

Download from [virtualbox.com](https://www.virtualbox.org/wiki/Downloads) or [click here](https://download.virtualbox.org/virtualbox/6.0.2/VirtualBox-6.0.2-128162-Win.exe)

### Ubuntu

Download the Ubuntu 18.04.1 LTS ISO from Ubuntu or [click here](https://www.ubuntu.com/download/desktop/thank-you?country=US&version=18.04.1&architecture=amd64)

## Setup Virtual Box

### Create new VM

#### Create new Virtual Machine

Click the blue "New" button at the top of VirtualBox Manager, the following dialog will appear.

##### Enter details

- Name the VM: "Ubuntu VM"
- You can leave the machine folder as default, or enter a custom path if desired. 
- Select "Linux" from type dropdown
- Select Ubuntu 64-bit from Version dropdown

![](https://cdn.pbrd.co/images/HXZyTAY.png)

#### Specify memory size

It's suggested to allocate at least 4gb of ram 

![](https://cdn.pbrd.co/images/HXZQuMi.jpg)

#### Configure Hard Disk for VM

- Select "Create a Virtual Hard Disk Now" 
- Click **Continue** 

![](https://cdn.pbrd.co/images/HXZR9RO.jpg)

- Select VDI (VirtualBox Disk Image)
- Click **Continue**

![](https://cdn.pbrd.co/images/HXZRBFJ.jpg)

- Select "Dynamically Allocated"
- Click **Continue**

![](https://cdn.pbrd.co/images/HXZS3Ot.jpg)

- Select at least 25GB with the slider
- Click **Create**

![](https://cdn.pbrd.co/images/HXZSdP8.jpg)

#### Select CPU Cores
- Click System
- Select at least 2 cores, if you select less than 2 cores, you may experience issues when compiling smart contracts. 
- Leave execution cap at 100%. 
- Click **Create**

![](https://cdn.pbrd.co/images/HXZSkhJ.jpg)

#### Mount ISO Image

- Click "Storage" in menu bar
- In the Storage Devices section on the left, select "Empty" under "Controller: IDE." 
- Click the *Blue CD Icon* to the right of the optical drive dropdown. 
- Select the `ubuntu-18.04.1-desktop-amd64.iso` file you downloaded in the previous step. 
- Click "Open" in the file dialog. 
- Click "Ok" in the Ubuntu VM System Options in VirtualBox. 

You're now done setting up the Ubuntu VM. 

![](https://cdn.pbrd.co/images/HXZSsh4.jpg)



## Install Ubuntu

### Boot VM
- Select the VM you just created in VirtualBox Manager
- Click the green "Start" button

Ubuntu 18.04.1 will boot.

Select your language and click "Install Ubuntu"

![](https://cdn.pbrd.co/images/HXZSClc.jpg)

For the next screens, use default settings and click **next** until you arrive at the "Who are you?" step. 

When you're there, fill out your details and click **Continue**

![](https://cdn.pbrd.co/images/HXZSLNy.jpg)

Installation will begin, the VM will restart and boot up.

## Install Git

- Open the application called "Terminal"
- Enter `sudo apt -y install git` 
- Enter the Ubuntu password you chose during the installation process. 
- Press enter
- wait for installation to complete.

# Complete

Now that you're finished setting up an Ubuntu VM, [Continue](instructions.md)