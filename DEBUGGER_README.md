# DEBUGGER README (Windows)

To make use of xdebug in the docker container, you have to correctly set `xdebug.remote_host=dockershostip` in `./config/php/php.ini`. On windows this is not equal to the regular ip address on the local network. It's the DockerNat also referred to as Ethernet adapter vEthernet (WSL) in ipconfig.