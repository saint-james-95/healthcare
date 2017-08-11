# Take Backend Env, Application files, Command, and Image Name
# Combine into one image

# USAGE: Backend Image -- App Files Dir Host -- Command -- App Image Name --App Files Dir Container
cat > Dockerfile << EOF
FROM $1
WORKDIR /root
COPY . $5	
ENTRYPOINT ["/bin/sh"]
CMD [$3]
EOF

mv -f Dockerfile $2
sudo docker build -t $4 $2 
