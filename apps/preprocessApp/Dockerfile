FROM backend/backend:master
WORKDIR /root
COPY . /big/medicare-demo	
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "service ssh start && sleep 10 && /root/start-hadoop.sh && cd /big/medicare-demo && /big/medicare-demo/run1.sh"]
