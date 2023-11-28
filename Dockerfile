FROM mcr.microsoft.com/windows/servercore:ltsc2019

LABEL Description="Apache-PHP" Vendor1="Apache Software Foundation" Version1="2.4.58" Vendor2="The PHP Group" Version2="8.3.0"

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Method Get -Uri https://github.com/cloudatwork/win-apache-php/raw/main/httpd-2.4.58-win64-VS17.zip -OutFile c:\apache.zip ; \
    Expand-Archive -Path c:\apache.zip -DestinationPath c:\ ; \
    Remove-Item c:\apache.zip -Force

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Method Get -Uri https://github.com/cloudatwork/win-apache-php/raw/main/VC_redist.x64.exe -OutFile c:\vcredist_x64.exe ; \
    start-Process c:\vcredist_x64.exe -ArgumentList '/quiet' -Wait ; \
    Remove-Item c:\vcredist_x64.exe -Force

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Method Get -Uri https://github.com/cloudatwork/win-apache-php/raw/main/php-8.1.26-Win32-vs16-x64.zip -OutFile c:\php.zip ; \
    Expand-Archive -Path c:\php.zip -DestinationPath c:\php ; \
    Remove-Item c:\php.zip -Force

RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
    Remove-Item c:\Apache24\conf\httpd.conf ; \
    new-item -Type Directory c:\www -Force ; \
    Add-Content -Value "'<?php phpinfo() ?>'" -Path c:\www\index.php

ADD httpd.conf /apache24/conf

WORKDIR /Apache24/bin

CMD /Apache24/bin/httpd.exe -w
