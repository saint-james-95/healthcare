FROM backend/backend:ubuntu
WORKDIR /root
COPY . /root	
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "cd /root/output && /root/collect.sh; exit"]
