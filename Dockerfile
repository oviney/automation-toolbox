FROM ubuntu:latest

MAINTAINER Ouray Viney "ouray@viney.ca"

ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
RUN apt-get update -qq && \
    echo 'Installing OS dependencies' && \
    apt-get update && \
    apt-get install -qq -y --fix-missing software-properties-common && \
    add-apt-repository ppa:mmk2410/intellij-idea && \
    apt-get install -qq -y --fix-missing intellij-idea-community gradle maven sudo software-properties-common git libxext-dev libxrender-dev libxslt1.1 libxtst-dev libgtk2.0-0 libcanberra-gtk-module unzip wget iputils-ping net-tools && \
    echo 'Cleaning up' && \
    apt-get clean -qq -y && \
    apt-get autoclean -qq -y && \
    apt-get autoremove -qq -y &&  \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

RUN echo 'Creating user: developer' && \
    mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    sudo echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    sudo chmod 0440 /etc/sudoers.d/developer && \
    sudo chown developer:developer -R /home/developer && \
    sudo chown root:root /usr/bin/sudo && \
    chmod 4755 /usr/bin/sudo

RUN mkdir -p /home/developer/.IdeaIC2018.3/config/plugins

RUN chown developer:developer -R /home/developer/.IdeaIC2018.3.2

RUN cd /home/developer/.IdeaIC2018.3.2/config/plugins

RUN echo 'Installing Solar Link plugin.' && \
    wget https://plugins.jetbrains.com/plugin/download?rel=true&updateId=53739 -O solarlink.zip -q && \
    unzip -q solarlink.zip && \
    rm solarlink.zip

RUN echo 'Installing Cucumber for Java plugin' && \
    wget https://plugins.jetbrains.com/plugin/download?rel=true&updateId=53739 -O cucumberforjava.zip -q && \
    unzip -q cucumberforjava.zip && \
    rm cucumberforjava.zip

RUN sudo chown developer:developer -R /home/developer

USER developer
ENV HOME /home/developer
WORKDIR /home/developer
CMD intellij
