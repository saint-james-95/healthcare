FROM environment:master
WORKDIR /root
COPY . /big/medicare-demo
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "service ssh start && ./start-hadoop.sh && cd /big/medicare-demo && ./run1.sh ${PCT}; bash"]
