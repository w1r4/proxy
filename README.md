cross compile alpine
build using docker
docker build -t trojan-alpine -f Dockerfile.alpine .
copy output file
docker run --rm -v /home/codespace/trojan:/output --entrypoint /bin/sh trojan-alpine -c cp /usr/local/bin/trojan /output/trojan && chmod +x /output/trojan
