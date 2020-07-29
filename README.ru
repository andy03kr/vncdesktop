# vncdesktop

## � vncdesktop
������������� ��������� ������ � �������� ����� ������������ ��� ����������� ���������.
���� �� ���������� ������������ ���������� VNC ������ - �� ����� �������������� � �������� �������.
� ���� ������ vncdesktop ��������� ������ ������� � ������ �������.
����������:
PLINK.EXE � PUTTYGEN.EXE �� ������ putty - ��� �������� ����������� ����������� � ������ ������� � ����������� ���������� �����
setpasswd.exe � winvnc.exe �� ������ UltraVNC - ���, ���������������, ������� � �������� �����
7zSD.sfx �� ������ LZMA SDK - ��� �������� SFX-������
AutoIT - ��� ��������� ������� � ������

## ����������
Linux ��������� � ��������� �������.
Windows ��������� � ������������� AutoIT ��� ��������� ��������� � ������������
����� [putty.zip](https://the.earth.li/~sgtatham/putty/latest/w32/putty.zip)
����� [UltraVNC](https://www.uvnc.com/downloads/ultravnc/129-download-ultravnc-1231.html)
����� [7zip]https://www.7-zip.org/download.html)
����� [LZMA SDK](https://www.7-zip.org/sdk.html)

## ���������
### Linux ���������
� ������ ������� ����� �������������� ��� vncproxy.home.lan
������� ������������:
> useradd -d /home/vncproxy -s /bin/bash vncproxy
> su vncproxy
> cd /home/vncproxy
> ssh_keygen
> cat .ssh/id_rsa.pub >> /home/vncproxy/.ssh/authorized_keys
� ����� /etc/ssh/sshd_config ��������:
> Port 22022
> GatewayPorts yes
��������� ��������� /etc/ssh/sshd_config �� ���� ����������
��������� �������
> iptables -I INPUT -p tcp --dport 22022 -j ACCEPT
> iptables -I INPUT -p tcp --dport 40000:50000 -j ACCEPT
���
> firewalld-cmd --permanent --add-port=22022/tcp
> firewalld-cmd --permanent --add-port=40000/tcp:50000/tcp
���� .ssh/id_rsa �������� �� Windows ���������
> usermod -s /bin/false vncproxy

### Windows ���������
��������� � ����������� ����� vncdesktop
���������� [AutoIT](https://www.autoitscript.com/cgi-bin/getfile.pl?autoit3/autoit-v3-setup.exe)
��������������� ����� putty � c:\putty
� ��������� ������ ������� � ������� c:\putty � ��������� PUTTYGEN.EXE
� ���� "Conversions" - "Import Key" ������������� ���� id_rsa - "Save private key" - ��������� ��� vncproxy.ppk � ������� vncdesktop\bin\
��� ��������� hostkey, ���������
> plink.exe -ssh -N -R 45554:127.0.0.1:5900 -P 22022 -i vncdesktop\bin\vncproxy.ppk -l vncproxy -batch vncproxy.home.lan
>> The server's host key is not cached in the registry. You
>> have no guarantee that the server is the computer you think it is.
>> The server's ssh-ed25519 key fingerprint is:
>> ssh-ed25519 255 24:b1:c4:9e:c9:b5:d6:e6:03:f2:df:1f:64:dd:81:1d
>> Connection abandoned.
������ "24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d" �������� � ���� vncdesktop.ini ��������
> hostkey="24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d"
� ���� vncdesktop.ini ���������
���������� ������ ������
> server=vncproxy.home.lan
���� �� ������� �������� ssh ����� �������
> sshport=22022
���� �� ������� ����� �������� ��������� VNC ������
> vncport=15900
������������ ������ �������
> sshuser=vncproxy
��� �����
> certificate=vncproxy.ppk
��������� ������ �������
> hostkey="24:b1:c4:9e:c9:b5:d6:e6:03:f2:df:1f:64:dd:81:1d"
�� ������ UltraVNC ����������� setpasswd.exe, winvnc.exe � UltraVNC.ini
� ���� UltraVNC.ini �������� ��� �������� ���������
> RemoveWallpaper=1
> RemoveAero=1
> AllowLoopback=1
> DefaultScale=1
> DisableTrayIcon=1
> PortNumber=15900
> noscreensaver=1
� SciTE Script Editor ������� ���� vncdesktop.au3 ������ F5 - ���������� ������.
�� ������ ���������� ��������� vncviewer vncproxy.home.lan:"Your ID"
���� �� Windows ���������� ���������� VNC ������, ����� "Mode" ����� "service mode" � ������ ����� �������������� �������� ��� ���������.
���� ������� ������������ ��� ������, ����� ������� ������ - ������ F7. � �������� � ������ vncdesktop.au3 ����� ������ ���� vncdesktop.exe
� �������� vncdesktop ������� ������� build.
������� �����:
> "c:\Program Files\7-Zip\7z.exe" a -r build\vncdesktop.7z bin vncdesktop.exe
����������� � ������� build 7zSD.sfx
������� ��������� ���� config.txt
> ;!@Install@!UTF-8!
> Title="vncdesktop v1.0.0.0"
> BeginPrompt="Do you want to install/run vncdesktop v1.0.0.0?"
> RunProgram="vncdesktop.exe"
> ;!@InstallEnd@!
����� ���������
> copy /b 7zSD.sfx + config.txt + vncdesktop.7z vncdesktop.exe
����� ������ vncdesktop.exe ������� ����� ��������� � ��������� ������ ������