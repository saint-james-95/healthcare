FROM environment:master2
WORKDIR /root
COPY . /big/medicare-demo
RUN cd /big/medicare-demo/socialite && ant 
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "service ssh start && sleep 5 && ./start-hadoop.sh && cd /big/medicare-demo && ./run2.sh ${PCT}; bash"]

