sudo su

cd

sudo apt update

sudo apt upgrade

echo "deb [arch=amd64] https://some.repository.url focal main" | sudo tee /etc/apt/sources.list.d/adoptium.list > /dev/nul
apt install -y wget apt-transport-https gpg

wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null

echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list

apt update

apt install temurin-17-jdk

wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.8/bin/apache-tomcat-10.1.8.tar.gz

tar xzf  apache-tomcat-10.1.8.tar.gz

mv ./apache-tomcat-10.1.8 /opt

sudo useradd -r -m -U -d /opt/tomcat -s /bin/false tomcat

sudo chgrp -R tomcat /opt/tomcat

sudo chmod -R 750 /opt/apache-tomcat-10.1.8/conf


sudo chown -R tomcat  /opt/apache-tomcat-10.1.8/webapps
sudo chown -R tomcat /opt/apache-tomcat-10.1.8/work
sudo chown -R tomcat /opt/apache-tomcat-10.1.8/temp
sudo chown -R tomcat /opt/apache-tomcat-10.1.8/logs



sudo echo "[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/temurin-17-jdk-amd64
Environment=CATALINA_PID=/opt/apache-tomcat-10.1.8/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/apache-tomcat-10.1.8
Environment=CATALINA_BASE=/opt/apache-tomcat-10.1.8
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/apache-tomcat-10.1.8/bin/startup.sh
ExecStop=/opt/apache-tomcat-10.1.8/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/tomcat.service

sudo systemctl daemon-reload

sudo systemctl enable tomcat

sudo vim /opt/apache-tomcat-10.1.8/conf/tomcat-users.xml
