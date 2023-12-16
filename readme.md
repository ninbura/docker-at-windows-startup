# summary 
The purpose of this repository is to assist with setting up services in Linux & tasks within Windows that allow you to reliably start Docker containers at boot of Windows.

# prerequisites
- administrator access in Windows
- root/sudo access in your WSL image
- If you installed Docker Desktop at any point in the past you will have to do the following
  - [uninstall docker desktop](https://docs.docker.com/desktop/uninstall/)
  - backup any important data in your wsl images
  - [unregister all wsl images](https://learn.microsoft.com/en-us/windows/wsl/faq) (`--unregister <distroName>` | all data in your image will be erased!)
  - re-install an image (ie Ubuntu from the Microsoft Store)

# setup
1. Verify that systemd is enabled in your wsl image.
  - this should be enabled by default
  - you can verify that this is case by checking you `wsl.conf` file in `/etc/wsl.conf`
  - said configuration file should contain these lines
  ```conf
  [boot]
  systemd=true
  ``` 
