FROM environment:master
WORKDIR /root
COPY . /big/medicare-demo
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "service ssh start && sleep 5 && ./start-hadoop.sh && cd /big/medicare-demo/socialite && ant && cd /big/medicare-demo && ./run2.sh ${PCT}; bash"]


