FROM microsoft/windowsservercore:latest

#add iis dont need this yet
#RUN powershell -Command Add-WindowsFeature Web-Server

#add full framework dont think i need this for console apps running on full frmaework or raw kestrel so long as 46 framework installed on server
#RUN powershell -Command Add-WindowsFeature NET-Framework-45-ASPNET
#RUN powershell -Command Add-WindowsFeature Web-Asp-Net45

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 1.0.0-preview2-003131
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/preview/Binaries/$DOTNET_SDK_VERSION/dotnet-dev-win-x64.$DOTNET_SDK_VERSION.zip

RUN powershell -NoProfile -Command \
        $ErrorActionPreference = 'Stop'; \
        Invoke-WebRequest %DOTNET_SDK_DOWNLOAD_URL% -OutFile dotnet.zip; \
        Expand-Archive dotnet.zip -DestinationPath '%ProgramFiles%\dotnet'; \
        Remove-Item -Force dotnet.zip

RUN setx /M PATH "%PATH%;%ProgramFiles%\dotnet"

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    && cd .. \
    && rmdir /q/s warmup

