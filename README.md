#UPDATE - fixed!
I needed to install the full framework sdk dev pack inside the container... kind of obvious really...oh well

# docker-testing Windows server Core 2016

The initial idea is to get a Docker windowsservercore container running that can be a build environment for some exploratory Docker testing. Trying to test that dotnet restore, dotnet run etc can work inside the container (using a mounted volume for source code). This has to be on the full framework either net451 or 461.

Later i will work on deployment image(s) for the app.

Can see the potential of Docker for lots of stuff 
1. build process / build agent / dev env
2. QA setups and test scenarios
3. Onboarding new devs
4. Deployment

I've already had problems trying to get "net use" to work within the running windows server core container (seems ok on nano server tests but fails on servercore) but thats another story.

# some context
We currently have a LOB app that runs on the full framework on ASP.NET Core 1.0.1. Part of this app is a SPA web front end with web api on kestrel behind iis and there is another component running on the full framework (project.json style again) that is installed as a windows service...processing background jobs that operate on network data. The background and distributed processing of jobs is using hangfire. We have a SQL Server db in the mix too. Currently these are installed on Windows Server 2012R2 using a zip file and then doing the extraction of the different components and installation of them with PowerShell. So ultimate idea is to see if we can containerise the application allowing for flexible hybrid deployment scenarios microservices etc...

# the setup and issue
The dummy source code is two apps... one for asp.net core web api on full framework (out of the box vs template) and a console app (dot net core stylee) running on the full framework.

I'm running windows 10 anniversary edition with the latest docker beta train and windows containers.

The dockerfile contains what i think should be enough to install the dotnet cli and do a simple dotnet restore and dotnet run on the console app is in the repo.

The container is launched by doing

docker run -it -v "C:\git\docker-testing:C:\docker-testing" full-framework-dev-image

Interactively (inside the running container) inside the mounted volume dir for the consoleapp project i then do a dotnet restore whick works fine but a dotnet run fails!

This is the output 

C:\>cd docker-testing\src\ConsoleFullFramework

C:\docker-testing\src\ConsoleFullFramework>dotnet restore
log  : Restoring packages for C:\docker-testing\src\ConsoleFullFramework\project.json...
log  : Lock file has not changed. Skipping lock file write. Path: C:\docker-testing\src\ConsoleFullFramework\project.lock.json
log  : C:\docker-testing\src\ConsoleFullFramework\project.json
log  : Restore completed in 85ms.

C:\docker-testing\src\ConsoleFullFramework>dotnet run
Project ConsoleFullFramework (.NETFramework,Version=v4.6.1) will be compiled because expected outputs are missing
Compiling ConsoleFullFramework for .NETFramework,Version=v4.6.1
C:\Program Files\dotnet\dotnet.exe compile-csc @C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.rsp returned Exit Code 1
C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.assemblyinfo.cs(2,11): error CS0246: The type or namespace name 'System' could not be
found (are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.assemblyinfo.cs(3,11): error CS0246: The type or namespace name 'System' could not be
found (are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.assemblyinfo.cs(4,11): error CS0246: The type or namespace name 'System' could not be
found (are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.assemblyinfo.cs(5,11): error CS0246: The type or namespace name 'System' could not be
found (are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(8,12): error CS0246: The type or namespace name 'AssemblyConfigurationAttribute' could not
be found (are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(8,12): error CS0246: The type or namespace name 'AssemblyConfiguration' could not be found
(are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(9,12): error CS0246: The type or namespace name 'AssemblyCompanyAttribute' could not be fou
nd (are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(9,12): error CS0246: The type or namespace name 'AssemblyCompany' could not be found (are y
ou missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(10,12): error CS0246: The type or namespace name 'AssemblyProductAttribute' could not be fo
und (are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(10,12): error CS0246: The type or namespace name 'AssemblyProduct' could not be found (are
you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(11,12): error CS0246: The type or namespace name 'AssemblyTrademarkAttribute' could not be
found (are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(11,12): error CS0246: The type or namespace name 'AssemblyTrademark' could not be found (ar
e you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(16,12): error CS0246: The type or namespace name 'ComVisibleAttribute' could not be found (
are you missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(16,12): error CS0246: The type or namespace name 'ComVisible' could not be found (are you m
issing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(19,12): error CS0246: The type or namespace name 'GuidAttribute' could not be found (are yo
u missing a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(19,12): error CS0246: The type or namespace name 'Guid' could not be found (are you missing
 a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.assemblyinfo.cs(2,58): error CS0518: Predefined type 'System.String' is not defined or
 imported
C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.assemblyinfo.cs(3,54): error CS0518: Predefined type 'System.String' is not defined or
 imported
C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.assemblyinfo.cs(4,67): error CS0518: Predefined type 'System.String' is not defined or
 imported
C:\docker-testing\src\ConsoleFullFramework\obj\Debug\net461\dotnet-compile.assemblyinfo.cs(5,62): error CS0518: Predefined type 'System.String' is not defined or
 imported
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(8,34): error CS0518: Predefined type 'System.String' is not defined or imported
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(9,28): error CS0518: Predefined type 'System.String' is not defined or imported
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(10,28): error CS0518: Predefined type 'System.String' is not defined or imported
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(11,30): error CS0518: Predefined type 'System.String' is not defined or imported
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(16,23): error CS0518: Predefined type 'System.Boolean' is not defined or imported
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(19,17): error CS0518: Predefined type 'System.String' is not defined or imported
C:\docker-testing\src\ConsoleFullFramework\Program.cs(1,7): error CS0246: The type or namespace name 'System' could not be found (are you missing a using directi
ve or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Program.cs(2,7): error CS0246: The type or namespace name 'System' could not be found (are you missing a using directi
ve or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Program.cs(3,7): error CS0246: The type or namespace name 'System' could not be found (are you missing a using directi
ve or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Program.cs(4,7): error CS0246: The type or namespace name 'System' could not be found (are you missing a using directi
ve or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(1,7): error CS0246: The type or namespace name 'System' could not be found (are you missing
 a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(2,7): error CS0246: The type or namespace name 'System' could not be found (are you missing
 a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Properties\AssemblyInfo.cs(3,7): error CS0246: The type or namespace name 'System' could not be found (are you missing
 a using directive or an assembly reference?)
C:\docker-testing\src\ConsoleFullFramework\Program.cs(8,16): error CS0518: Predefined type 'System.Object' is not defined or imported
C:\docker-testing\src\ConsoleFullFramework\Program.cs(10,29): error CS0518: Predefined type 'System.String' is not defined or imported
C:\docker-testing\src\ConsoleFullFramework\Program.cs(10,19): error CS0518: Predefined type 'System.Void' is not defined or imported

Compilation failed.
    0 Warning(s)
    36 Error(s)

Time elapsed 00:00:01.8476653


C:\docker-testing\src\ConsoleFullFramework>

# Questions
In my mind the Dockerfile and setup should allow this to work for the full framework and dotnet cli. i dont understand why it doesnt. The full framework 46 is installed in the container and ive checked this with Get-WindowsFeature in PowerShell.
Is this a bug or expected to work?
Is this me not understanding something?

Glenn pointed out that i could be missing ANCM (which im thinking is the server hosting bundle we install that gives us aspnetcore iis module) but i'm not even to the point of hosting in IIS and therefore dont see why this is needed for a simple dotnet run of a console app...

Any help would be appreciated? :-)
