FROM environment:ubuntu
WORKDIR /root
RUN mkdir output
COPY . /root
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "cd /root/output && /root/collect.sh; exit"]

