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
1. ### Verify that systemd is enabled in your wsl image.
    - this should be enabled by default
    - you can verify that this is case by checking you `wsl.conf` file in `/etc/wsl.conf`
    - Said configuration file should contain the following lines (if not, add them).
    - ```conf
      [boot]
      systemd=true
      ```
2. ### [Install Docker](https://docs.docker.com/engine/install/ubuntu)
    - make sure to [uninstall old versions of Docker](https://docs.docker.com/engine/install/ubuntu/#uninstall-old-versions) first
    - After verifying that old versions have been uninstall, I recommend using their [convenience script](https://docs.docker.com/engine/install/ubuntu/#install-using-the-convenience-script) for installation.
3. ### [Follow Docker's post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/)
    - add your user to the docker user group
    - enable Docker via systemd
4. ### Create a systemd service file to start your Docker containers at boot
    - your service file must created in `/etc/systemd/system` (`sudo touch /etc/systemd/system/my-service.service)
    - replace bracketed info fields with proper info
    - ```service
      [Unit]
      Description=[description of service]
      Requires=docker.service
      After=docker.service
    
      [Service]
      Type=oneshot
      RemainAfterExit=yes
      WorkingDirectory=[directory where your docker-compose file lives from root]
      ExecStart=/bin/bash -c "docker compose up -d"
      ExecStop=/bin/bash -c "docker compose down"
      TimeoutStartSec=0
    
      [Install]
      WantedBy=multi-user.target
      ```
5. ### enable your custom service with systemd
```bash
sudo systemctl enable my-service.service
```
6. ### create a scheduled task in Windows that starts your wsl image at boot
    1. clone this repository to a direcoty **in Windows**
    2. in the root of your cloned repository add a `config.json` with the follwing content
    - ```json
      {
            "imageName": "your-wsl-image-name" // ie "Ubuntu"
      }
      ```
    3. right click `~register-scheduled-task.bat` and run as administrator
    4. follow prompts
        - You will be prompted to enter the password for the current user.
        - This is required as WSL is bound per user, you can't start WSl as the System user.
        - Your password is captured as a secure string and is never stored or converted to plain text.
7. ### reboot your computer
    - If you followed all the previous steps correctly Docker / your containers should be running.
    - you can verify if your containers are running by using the `docker ps` command in bash (on linux).

# troubleshooting
There's a lot that can go wrong here, it would be impossible to cover everyting. So, I'll just cover some basics. If your Docker / your containers aren't running, try the folling.
1. verify that docker is running - `sudo systemctl status docker`
    - If Docker failed to start, try diagnosing with `sudo dockerd`.
3. verify that your custom service is running - `sudo systemctl status my-service.service`
    - If your custom service failed to start, try and troubleshoot the contents of the printed status.
5. verify that your Windows scheduled task exectuted
    - there should be a `start-wsl.log` in the root of your cloned repository
    - if there is no log file you can view failed scheduled tasks in Windows' Event Viewer
        - 

