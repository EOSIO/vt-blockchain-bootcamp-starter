# Step 1: Enable Windows Subsystem for Linux (WSL) 
First, you're need to enable WSL

1. Open PowerShell application as an administrator ([How to](https://www.thewindowsclub.com/how-to-open-an-elevated-powershell-prompt-in-windows-10))
2. Execute the following command within the PowerShell window. 
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux 
```
3. Restart your computer when the prompt is shown. 

# Step 2: Download Ubuntu 18.04
4. Open *Microsoft Store*
5. Search for Ubuntu 18.04
6. Click the blue "Get" button at the top right of the page. 

# Step 3: Configure Ubuntu 18.04 on WSL
7. Launch **Ubuntu 18.04** Windows Application
8. Configure your username and password.

# Complete
Now that you've installed WSL and Ubuntu 18.04, please [continue](instructions.md)