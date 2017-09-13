FROM nbdif/healthcare:hadoop_base_slave

WORKDIR /root

# file changes
RUN sed -i 's/PermitRootLogin\swithout-password/PermitRootLogin\ yes/g' /etc/ssh/sshd_config && \
    sed -i 's/RhostsRSAAuthentication\sno/RhostsRSAAuthentication\ yes/g' /etc/ssh/sshd_config

# extra installs
RUN apt-get update && apt-get install -y net-tools git curl ant python-pandas python-pip

# pip installs
RUN pip install numpy && pip install pandas

# install pig
RUN mkdir /big && \
    cd /big && \
    wget http://apache.cs.utah.edu/pig/pig-0.16.0/pig-0.16.0.tar.gz && \
    tar xvf pig-*gz

ENV PIG_HOME=/big/pig-0.16.0
ENV PIG_CONF_DIR=$PIG_HOME/conf
ENV PIG_CLASSPATH=$PIG_CONF_DIR \
    PATH=$PIG_HOME/bin:$PATH

# compile pig
RUN cd /big/pig-* && \
    ant

# for data volume
RUN mkdir -p /big/medicare-demo/ref_data

