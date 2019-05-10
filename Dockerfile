FROM openjdk:11-jre-slim
MAINTAINER Jazy <jazy@jazyserver.com>

ARG spigot_version="1.14"

RUN mkdir /minecraft

# Get build deps
RUN set -x \
  && apt-get update \
  && apt-get install -y --no-install-recommends --no-install-suggests \
    wget vim git \
  && rm -rf /var/lib/apt/lists/*

# Build the spigot server
RUN set -x \
  && mkdir /build \
  && wget -O /build/buildtools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar \
  && java -jar /build/buildtools.jar --rev $spigot_version \
  && mv spigot-${spigot_version}.jar /minecraft/ \
  && rm -r /build

# Remove build deps
RUN set -x \
  && apt-get purge -y \
    wget vim git \
  && apt-get autoremove -y

COPY eula.txt /minecraft/
COPY server.properties /minecraft/server.properties
COPY start-minecraft-server.sh /

VOLUME /minecraft
EXPOSE 25565

WORKDIR /minecraft
CMD ["/bin/sh", "/start-minecraft-server.sh"]
