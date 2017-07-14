FROM saintjames95/hadoop:base-config

WORKDIR /root

# file changes
RUN sed -i 's/PermitRootLogin\swithout-password/PermitRootLogin\ yes/g' /etc/ssh/sshd_config && \
    sed -i 's/RhostsRSAAuthentication\sno/RhostsRSAAuthentication\ yes/g' /etc/ssh/sshd_config

# extra installs
RUN apt-get -y install net-tools git curl ant python-pandas && apt-get -y install python-pip

# pip installs
RUN pip install numpy && pip install pandas

# install pig
RUN mkdir /big && \ 
    cd /big && \
    wget http://apache.cs.utah.edu/pig/pig-0.16.0/pig-0.16.0.tar.gz && \
    tar xvf pig-*gz

# compile pig
RUN cd /big/pig-* && \
    ant        

CMD [ "sh", "-c", "service ssh start; bash"]