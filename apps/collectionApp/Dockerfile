FROM nbdif/common:environment
WORKDIR /root
RUN mkdir output
COPY . /root
ENTRYPOINT ["/bin/sh"]
CMD ["-c", "cd /root/output && chmod +x /root/collect.sh && /root/collect.sh && chown -R --reference=. ./*; bash"]

