# vncdesktop

## О vncdesktop
Предоставляет удаленный доступ к рабочему столу пользователя для технической поддержки.
Если на компьютере пользователя установлен VNC сервер - он будет использоваться с заданным паролем.
В этом случае vncdesktop обеспечит только тунелем к прокси серверу.
Использует:
PLINK.EXE и PUTTYGEN.EXE из пакета putty - для создания безопасного подключения к прокси серверу и конвертации приватного ключа
setpasswd.exe и winvnc.exe из пакета UltraVNC - для, непосредственно, доступа к рабочему столу
7zSD.sfx из пакета LZMA SDK - для создания SFX-архива
AutoIT - для тестового запуска и сборки

## Требования
Linux компьютер с публичным адресом.
Windows компьютер с установленным AutoIT для первичной настройки и тестирования
Пакет [putty.zip](https://the.earth.li/~sgtatham/putty/latest/w32/putty.zip)
Пакет [UltraVNC](https://www.uvnc.com/downloads/ultravnc/129-download-ultravnc-1231.html)
Пакет [7zip]https://www.7-zip.org/download.html)
Пакет [LZMA SDK](https://www.7-zip.org/sdk.html)

## Установка
### Linux компьютер
В данном примере будет использоваться имя vncproxy.home.lan
Создать пользователя:
> useradd -d /home/vncproxy -s /bin/bash vncproxy
> su vncproxy
> cd /home/vncproxy
> ssh_keygen
> cat .ssh/id_rsa.pub >> /home/vncproxy/.ssh/authorized_keys
В файле /etc/ssh/sshd_config добавить:
> Port 22022
> GatewayPorts yes
Остальные настройки /etc/ssh/sshd_config на свое усмотрение
Настроить фаервол
> iptables -I INPUT -p tcp --dport 22022 -j ACCEPT
> iptables -I INPUT -p tcp --dport 40000:50000 -j ACCEPT
или
> firewalld-cmd --permanent --add-port=22022/tcp
> firewalld-cmd --permanent --add-port=40000/tcp:50000/tcp
Файл .ssh/id_rsa передать на Windows компьютер
> usermod -s /bin/false vncproxy

### Windows компьютер
Загрузить и распаковать архив vncdesktop
Установить [AutoIT](https://www.autoitscript.com/cgi-bin/getfile.pl?autoit3/autoit-v3-setup.exe)
Разархивировать архив putty в c:\putty
В командной строке перейти в каталог c:\putty и выполнить PUTTYGEN.EXE
В меню "Conversions" - "Import Key" импортировать ключ id_rsa - "Save private key" - сохранить как vncproxy.ppk в каталог vncdesktop\bin\
Для получения hostkey, выполнить
> plink.exe -ssh -N -R 45554:127.0.0.1:5900 -P 22022 -i vncdesktop\bin\vncproxy.ppk -l vncproxy -batch vncproxy.home.lan
>> The server's host key is not cached in the registry. You
>> have no guarantee that the server is the computer you think it is.
>> The server's ssh-ed25519 key fingerprint is:
>> ssh-ed25519 255 24:b1:c4:9e:c9:b5:d6:e6:03:f2:df:1f:64:dd:81:1d
>> Connection abandoned.
Строку "24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d" добавить в файл vncdesktop.ini параметр
> hostkey="24:b1:c4:9e:c9:b5:d6:e6:03:12:df:1f:64:dd:81:1d"
В файл vncdesktop.ini параметры
определяет прокси сервер
> server=vncproxy.home.lan
порт на котором работает ssh проки сервера
> sshport=22022
порт на котором будет работать локальный VNC сервер
> vncport=15900
пользователь прокси сервера
> sshuser=vncproxy
имя файла
> certificate=vncproxy.ppk
отпечаток прокси сервера
> hostkey="24:b1:c4:9e:c9:b5:d6:e6:03:f2:df:1f:64:dd:81:1d"
Из пакета UltraVNC понадобится setpasswd.exe, winvnc.exe и UltraVNC.ini
В файл UltraVNC.ini добавить или изменить параметры
> RemoveWallpaper=1
> RemoveAero=1
> AllowLoopback=1
> DefaultScale=1
> DisableTrayIcon=1
> PortNumber=15900
> noscreensaver=1
В SciTE Script Editor открыть файл vncdesktop.au3 нажать F5 - запустится проект.
На другом компьютере запустить vncviewer vncproxy.home.lan:"Your ID"
Если на Windows компьютере установлен VNC сервер, режим "Mode" будет "service mode" и пароль будет использоваться заданный при установке.
Если удалось подключиться без ошибок, можно собрать проект - нажать F7. В каталоге с файлом vncdesktop.au3 будет создан файл vncdesktop.exe
В каталоге vncdesktop создать каталог build.
Создать архив:
> "c:\Program Files\7-Zip\7z.exe" a -r build\vncdesktop.7z bin vncdesktop.exe
Скопировать в каталог build 7zSD.sfx
Создать текстовый файл config.txt
> ;!@Install@!UTF-8!
> Title="vncdesktop v1.0.0.0"
> BeginPrompt="Do you want to install/run vncdesktop v1.0.0.0?"
> RunProgram="vncdesktop.exe"
> ;!@InstallEnd@!
Затем выполнить
> copy /b 7zSD.sfx + config.txt + vncdesktop.7z vncdesktop.exe
Будет создан vncdesktop.exe который можно запустить и проверить работу пакета
