# vncdesktop
# README.EN
## About vncdesktop
Provides remote access to the user's desktop for technical support (similar to Teamviewer).

If a VNC server is installed on the user's computer, it will be used with the specified password.
In this case, vncdesktop will only provide a tunnel to the proxy server.

### Uses
- PLINK.EXE and PUTTYGEN.EXE from putty package - to create a secure connection to a proxy server and convert a private key.
- setpasswd.exe and winvnc.exe from UltraVNC package - for access to the desktop.
- 7zSD.sfx from the LZMA SDK package - to create an SFX archive.
- AutoIT - for test run and build.

## Requirements
- Linux computer with a public address
- Windows computer with AutoIT installed for initial setup and testing
- Package [putty.zip](https://the.earth.li/~sgtatham/putty/latest/w32/putty.zip)
- Package [UltraVNC](https://www.uvnc.com/downloads/ultravnc/129-download-ultravnc-1231.html)
- Package [7zip](https://www.7-zip.org/download.html)
- Package [LZMA SDK](https://www.7-zip.org/sdk.html)

## Installation
This example will use:
- linux server name - vncproxy.home.lan
- ssh port - 22022
- port range for VNC connections - 40000:50000
- project directory c:\vncdesktop\

### Linux computer
Create user:
```html
   useradd -d /home/vncproxy -s /bin/bash vncproxy
   su vncproxy
   cd /home/vncproxy
   ssh_keygen
   cat .ssh/id_rsa.pub >> /home/vncproxy/.ssh/authorized_keys
```
In the /etc/ssh/sshd_config file add:
```html
   Port 22022
   GatewayPorts yes
   ForceCommand /bin/false
```
The rest of the /etc/ssh/sshd_config settings at your discretion

Configure firewall
```html
   iptables -I INPUT -p tcp --dport 22022 -j ACCEPT
   iptables -I INPUT -p tcp --dport 40000:50000 -j ACCEPT
```
or
```html
   firewalld-cmd --permanent --add-port=22022/tcp
   firewalld-cmd --permanent --add-port=40000-50000/tcp
```
Transfer the .ssh/id_rsa file to the Windows computer
   > usermod -s /bin/false vncproxy

### Windows computer
Download and unpack the vncdesktop archive.
Install AutoIT.
Unzip the putty archive to c:\putty and run PUTTYGEN.EXE

In the "Conversions" - "Import Key" menu, import the id_rsa key - "Save private key" - save as vncproxy.ppk to the c:\vncdesktop\bin\ directory

To get the hostkey, on the command line, go to the c:\putty directory and run command
  > plink.exe -ssh -N -R 45554:127.0.0.1:5900 -P 22022 -i c:\vncdesktop\bin\vncproxy.ppk -l vncproxy -batch vncproxy.home.lan
```html
    The server's host key is not cached in the registry. You
    have no guarantee that the server is the computer you think it is.
    The server's ssh-ed25519 key fingerprint is:
    ssh-ed25519 255 24:b1:c4:9e:c9:b5:d6:e6:03:f2:df:1f:64:dd:81:1d
    Connection abandoned.
```
Add the line "24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d" to the vncdesktop.ini file
  > hostkey = "24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d"

In vncdesktop.ini file parameters
```html
    server = vncproxy.home.lan                                        #defines a proxy server
    sshport = 22022                                                   #the ssh port on proxy server
    vncport = 15900                                                   #local VNC port
    sshuser = vncproxy                                                #proxy server user
    certificate = vncproxy.ppk                                        #private key file name
    hostkey = "24:b1:c4:9e:c9:b5:d6:e6:03:f2:df:1f:64:dd:81:1d"       #proxy server fingerprint
```
From the UltraVNC package you will need setpasswd.exe, winvnc.exe and UltraVNC.ini
Add or change parameters to UltraVNC.ini file
```html
  RemoveWallpaper = 1
  RemoveAero = 1
  AllowLoopback = 1
  DefaultScale = 1
  DisableTrayIcon = 1
  PortNumber = 15900
  noscreensaver = 1
```
Open the vncdesktop.au3 file in SciTE Script Editor and press F5 - the project will start.

On another computer, run vncviewer vncproxy.home.lan:"Your ID"

If a VNC server is installed on a Windows computer, the "Mode" will be "service mode" and the password specified during installation.

### Build

If you were able to connect without errors, you can build the project - press F7. The file c:\vncdesktop\vncdesktop.exe will be created

Create an archive in the c:\vncdesktop\build directory:
  > "c:\Program Files\7-Zip\7z.exe" a -r c:\vncdesktop\build\vncdesktop.7z c:\vncdesktop\bin c:\vncdesktop\vncdesktop.exe

Copy file 7zSD.sfx to c:\vncdesktop\build directory
Create text file config.txt in c:\vncdesktop\build directory
```html
  ;! @ Install @! UTF-8!
  Title = "vncdesktop v1.0.0.0"
  BeginPrompt = "Do you want to install/run vncdesktop v1.0.0.0?"
  RunProgram = "vncdesktop.exe"
  ;! @ InstallEnd @!
```
Then, in the c:\vncdesktop\build directory, run
  > copy / b 7zSD.sfx + config.txt + vncdesktop.7z vncdesktop.exe

c:\vncdesktop\build\vncdesktop.exe will be created.

Run c:\vncdesktop\build\vncdesktop.exe

VNC started in service mode

![service mode](pictures/vncdesktop_svc.png)

VNC launched in application mode

![application mode](pictures/vncdesktop_app.png)

On another computer, run vncviewer vncproxy.home.lan:"Your ID" without quotes, for example
  > vncviewer vncproxy.home.lan:45792

# README.RU
## О vncdesktop
Предоставляет удаленный доступ к рабочему столу пользователя для технической поддержки (по аналоиги с Teamviewer).

Если на компьютере пользователя установлен VNC сервер - он будет использоваться с заданным паролем.
В этом случае vncdesktop обеспечит только тунелем к прокси серверу.

### Использует
- PLINK.EXE и PUTTYGEN.EXE из пакета putty - для создания безопасного подключения к прокси серверу и конвертации приватного ключа.
- setpasswd.exe и winvnc.exe из пакета UltraVNC - для, непосредственно, доступа к рабочему столу.
- 7zSD.sfx из пакета LZMA SDK - для создания SFX-архива.
- AutoIT - для тестового запуска и сборки.

## Требования
- Linux компьютер с публичным адресом
- Windows компьютер с установленным AutoIT для первичной настройки и тестирования
- Пакет [putty.zip](https://the.earth.li/~sgtatham/putty/latest/w32/putty.zip)
- Пакет [UltraVNC](https://www.uvnc.com/downloads/ultravnc/129-download-ultravnc-1231.html)
- Пакет [7zip](https://www.7-zip.org/download.html)
- Пакет [LZMA SDK](https://www.7-zip.org/sdk.html)

## Установка
В данном примере будет использоваться:
- имя linux сервера - vncproxy.home.lan
- ssh порт - 22022
- диапазон портов для VNC подключений - 40000:50000
- каталог проекта c:\vncdesktop\

### Linux компьютер
Создать пользователя:
```html
  useradd -d /home/vncproxy -s /bin/bash vncproxy
  su vncproxy
  cd /home/vncproxy
  ssh_keygen
  cat .ssh/id_rsa.pub >> /home/vncproxy/.ssh/authorized_keys
```
В файле /etc/ssh/sshd_config добавить:
```html
  Port 22022
  GatewayPorts yes
  ForceCommand /bin/false
```
Остальные настройки /etc/ssh/sshd_config на свое усмотрение

Настроить фаервол
```html
  iptables -I INPUT -p tcp --dport 22022 -j ACCEPT
  iptables -I INPUT -p tcp --dport 40000:50000 -j ACCEPT
```
или
```html
  firewalld-cmd --permanent --add-port=22022/tcp
  firewalld-cmd --permanent --add-port=40000-50000/tcp
```
Файл .ssh/id_rsa передать на Windows компьютер
  > usermod -s /bin/false vncproxy

### Windows компьютер
Загрузить и распаковать архив vncdesktop.
Установить AutoIT.
Разархивировать архив putty в c:\putty и выполнить PUTTYGEN.EXE

В меню "Conversions" - "Import Key" импортировать ключ id_rsa - "Save private key" - сохранить как vncproxy.ppk в каталог c:\vncdesktop\bin\

Для получения hostkey, в командной строке перейти в каталог c:\putty и выполнить
  > plink.exe -ssh -N -R 45554:127.0.0.1:5900 -P 22022 -i c:\vncdesktop\bin\vncproxy.ppk -l vncproxy -batch vncproxy.home.lan
```html
    The server's host key is not cached in the registry. You
    have no guarantee that the server is the computer you think it is.
    The server's ssh-ed25519 key fingerprint is:
    ssh-ed25519 255 24:b1:c4:9e:c9:b5:d6:e6:03:f2:df:1f:64:dd:81:1d
    Connection abandoned.
```
Строку "24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d" добавить в файл vncdesktop.ini параметр
  > hostkey="24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d"

В файл vncdesktop.ini параметры
```html
    server=vncproxy.home.lan                                        #определяет прокси сервер
    sshport=22022                                                   #порт на котором работает ssh проки сервера
    vncport=15900                                                   #порт на котором будет работать локальный VNC сервер
    sshuser=vncproxy                                                #пользователь прокси сервера
    certificate=vncproxy.ppk                                        #имя файла приватного ключа
    hostkey="24:b1:c4:9e:c9:b5:d6:e6:03:f2:df:1f:64:dd:81:1d"       #отпечаток прокси сервера
```
Из пакета UltraVNC понадобится setpasswd.exe, winvnc.exe и UltraVNC.ini
В файл UltraVNC.ini добавить или изменить параметры
```html
  RemoveWallpaper=1
  RemoveAero=1
  AllowLoopback=1
  DefaultScale=1
  DisableTrayIcon=1
  PortNumber=15900
  noscreensaver=1
```
В SciTE Script Editor открыть файл vncdesktop.au3 нажать F5 - запустится проект.

На другом компьютере запустить vncviewer vncproxy.home.lan:"Your ID"

Если на Windows компьютере установлен VNC сервер, режим "Mode" будет "service mode" и пароль будет использоваться заданный при установке.

### Сборка

Если удалось подключиться без ошибок, можно собрать проект - нажать F7. Будет создан файл c:\vncdesktop\vncdesktop.exe

В каталоге c:\vncdesktop\build создать архив:
  > "c:\Program Files\7-Zip\7z.exe" a -r c:\vncdesktop\build\vncdesktop.7z c:\vncdesktop\bin c:\vncdesktop\vncdesktop.exe

Скопировать в каталог build 7zSD.sfx
Создать текстовый файл config.txt в каталоге build
```html
  ;!@Install@!UTF-8!
  Title="vncdesktop v1.0.0.0"
  BeginPrompt="Do you want to install/run vncdesktop v1.0.0.0?"
  RunProgram="vncdesktop.exe"
  ;!@InstallEnd@!
```
Затем в каталоге c:\vncdesktop\build выполнить
 > copy /b 7zSD.sfx + config.txt + vncdesktop.7z vncdesktop.exe

Будет создан c:\vncdesktop\build\vncdesktop.exe

Запустите c:\vncdesktop\build\vncdesktop.exe

VNC запущен в режиме сервиса

![service mode](pictures/vncdesktop_svc.png)

VNC запущен в режиме приложения

![application mode](pictures/vncdesktop_app.png)

На другом компьютере запустить vncviewer vncproxy.home.lan:"Your ID" без кавычек, например
  > vncviewer vncproxy.home.lan:45792