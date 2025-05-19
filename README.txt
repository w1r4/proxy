cross compile alpine
build using docker
docker build -t trojan-alpine -f Dockerfile.alpine .
copy output file
docker cp trojan-temp:/usr/local/bin/trojan /home/codespace/trojan/trojan
