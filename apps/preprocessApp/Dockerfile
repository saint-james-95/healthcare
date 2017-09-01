FROM nbdif/healthcare:env_master1
WORKDIR /root
COPY . /big/medicare-demo
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "service ssh start && sleep 5 && ./start-hadoop.sh && cd /big/medicare-demo && ./run1.sh ${PCT}; bash"]
