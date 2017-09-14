FROM nbdif/healthcare:master1
WORKDIR /root
COPY . /big/medicare-demo
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "service ssh start && sleep 5 && ./start-hadoop.sh && cd /big/medicare-demo && chmod +x run1.sh && ./run1.sh ${PCT}; bash"]
