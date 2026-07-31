@echo off
echo Opening firewall for proxy sharing...
netsh advfirewall firewall add rule name="V2Ray-SOCKS" dir=in action=allow protocol=tcp localport=1081
netsh advfirewall firewall add rule name="V2Ray-HTTP" dir=in action=allow protocol=tcp localport=10810
netsh advfirewall firewall add rule name="V2Ray-JP" dir=in action=allow protocol=tcp localport=10820
netsh advfirewall firewall add rule name="V2Ray-US" dir=in action=allow protocol=tcp localport=10840
echo Done! Firewall opened for ports 1081, 10810, 10820, 10840
pause
