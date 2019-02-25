# problem:
shell/bash generate random alphanumeric string

# command:
cat /dev/urandom | tr -dc 'a-zA-z0-9' | fold -w 4 | head -n 1

# reference:
https://gist.github.com/earthgecko/3089509

***************************************************************************************

# problem:
if you want to convert new lines into spaces on a file using sed, then you can use

# command:
sed -i ':a;N;$!ba;s/\n/\t/g' file_with_line_breaks

# reference:
http://unix.stackexchange.com/questions/26788/using-sed-to-convert-newlines-into-spaces

****************************************************************************************

# problem:
command to get the string after last slash(/)

# command:
System.out.println(example.substring(example.lastIndexOf("/") + 1));

# reference:
http://stackoverflow.com/questions/14316487/java-getting-a-substring-from-a-string-starting-after-a-particular-character

****************************************************************************************

# Error:
File not found error 

when a directory is not exist in server then the scripts will keep on give file not found in console and 
it will get struct then the script will not proceed further 
manually we have to abort the connection to ftp by enterting ctrl+c 

How check whether a word exist in a file shell script
# solution:
grep -Fxq "$FILENAME" my_list.txt
# The exit status is 0 (true) if the name was found, 1 (false) if not, so:
if grep -Fxq "$FILENAME" my_list.txt
then
    # code if found
else
    # code if not found
fi

# reference:
http://stackoverflow.com/questions/4749330/how-to-test-if-string-exists-in-file-with-bash-shell

*************************************************************************************

# Error:
http://in.archive.ubuntu.com trusty Release.gpg
  Unable to connect to 10.138.1.90:3131:    # proxy server 


# solution:
check the file /etc/apt/apt.conf
The contents were,

Acquire::http::proxy "http://<proxy>:<port>/";
Acquire::ftp::proxy "ftp://<proxy>:<port>/";
Acquire::https::proxy "https://<proxy>:<port>/";

# This was the reason why you could reach proxy but couldn't get past it, since there is no username password information. So just put that info into it..

Acquire::http::proxy "http://<username>:<password>@<proxy>:<port>/";
Acquire::ftp::proxy "ftp://<username>:<password>@<proxy>:<port>/";
Acquire::https::proxy "https://<username>:<password>@<proxy>:<port>/";

if still not resolved do

env | grep proxy

# set up the proxy ip like following 
export http_proxy=http://ip:port/
export ftp_proxy=http://ip:port/
export socks_proxy=http://ip:port/
export https_proxy=http://ip:port/

# reference:
http://askubuntu.com/questions/89437/how-to-install-packages-with-apt-get-on-a-system-connected-via-proxy

********************************************************************************************

# Error:
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 cassandra : Depends: openjdk-8-jre-headless but it is not installable or
                      java8-runtime but it is not installable
E: Unable to correct problems, you have held broken packages.


# solution:
You need to install the openjdk-8-jre-headless from backports, run:

apt edit-sources  or vi /etc/apt/sources.list

add the following line:

deb http://httpredir.debian.org/debian jessie-backports main

Update :

apt-get update && apt-get upgrade
apt-get -f install

Install the needed package:

apt-get -t jessie-backports install openjdk-8-jre-headless 
	
    # Error:
	if you get and error like this here 
		The following packages have unmet dependencies:
		libgdiplus : Depends: libjpeg62-turbo (>= 1.3.1) but it is not installable
		E: Unable to correct problems, you have held broken packages.	
		
		# solution:
			wget http://ftp.br.debian.org/debian/pool/main/libj/libjpeg-turbo/libjpeg62-turbo_1.4.1-2_amd64.deb
			wget http://ftp.br.debian.org/debian/pool/main/libj/libjpeg6b/libjpeg62_6b2-2_amd64.deb
			sudo dpkg --install --recursive --auto-deconfigure libjpeg62-turbo_1.4.1-2_amd64.deb 
			apt-get update
			sudo apt-get -f install

		# reference:
			http://sushihan(98)Address already in use: AH00072: make_sock: could not bind to address [::]:80 (98)Address already in use: AH00072: make_sock: could not bind to address 0.0.0.0:80gover.github.io/mono-ubuntu-broken/

apt-get install ntp

Install cassandra:

apt-get install cassandra

# reference:
	http://stackoverflow.com/questions/39932818/installation-of-cassandra-fails-of-unmet-dependencies

*******************************************************************************************

# Error:
When get this error 

>>> /etc/sudoers: syntax error near line 23 <<<
sudo: parse error in /etc/sudoers near line 23
sudo: no valid sudoers sources found, quitting
sudo: unable to initialize policy plugin

# solution:
pkexec visudo

# reference:
https://askubuntu.com/questions/73864/how-to-modify-an-invalid-etc-sudoers-file-it-throws-an-error-and-its-not-allo
http://www.psychocats.net/ubuntu/fixsudo

*********************************************************************************************

# Error:
if you get this error in cloudera manager while adding host in cluster 
need root privileges but sudo requires password, exiting closing logging file descriptor 

# solution:
sudo visudo -f /etc/sudoers
usernameusedforlogin ALL=(ALL) NOPASSWD:ALL
esc :wq!

# Reference:
https://askubuntu.com/questions/239432/enable-passwordless-sudo-as-a-specific-user