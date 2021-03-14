# How To Debug Locally DEBUGGER README (Windows)

To make use of xdebug in the docker container, you have to correctly set `xdebug.remote_host=dockershostip` in `./application/web/devconfig/php/php.ini`. On windows this is not equal to the regular ip address on the local network. It's the DockerNat also referred to as Ethernet adapter vEthernet (WSL) in ipconfig. To determine the host ip in wsl, run `hostname -I` from the terminal.

If you want to debug .tpl files in visual code, mark them as php in the bottom right.