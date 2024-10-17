#!/bin/zsh
#docker login --username=XXX registry.cn-beijing.aliyuncs.com
date
version=$1

repo_domain=registry.cn-beijing.aliyuncs.com
repo_ns=first_ns_dingyue
imageName=java-httpbin
mvn clean package -Dmaven.test.skip=true
docker build --platform linux/amd64 -t $repo_domain/$repo_ns/$imageName:$version ./
#ImageId=`docker build -t $imageName:v1 ./ |grep "Successfully built"|awk -F" " '{print $3}'`
#docker tag $ImageId $repo_domain/$repo_ns/$imageName:$version
docker push $repo_domain/$repo_ns/$imageName:$version
date
