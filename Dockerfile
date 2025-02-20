# 安装 nginx


#compile stage
#FROM maven:3.6.3-openjdk-8 AS builder
 #  AS builder 起别名

#RUN mkdir /build
# 创建临时文件

#ADD src /build/src
#将 src目录复制到临时目录

#ADD pom.xml /build
# 将 pom文件复制到临时目录

#RUN cd /build && mvn clean package -Dmaven.test.skip=true


#build stage
#FROM mamohr/centos-java:jdk8
FROM dragonwell-registry.cn-hangzhou.cr.aliyuncs.com/dragonwell/dragonwell:11

WORKDIR /

RUN groupadd polaris && adduser -u 1200 -g polaris polaris
USER 1200

#COPY target/*.jar /app.jar
COPY target/httpbin-1.5.0-SNAPSHOT-jar-with-dependencies.jar /app.jar
# add debug port
ENV JAVA_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
ENV SERVER_PORT=8080

EXPOSE ${SERVER_PORT}

HEALTHCHECK --interval=10s --timeout=3s \
	CMD curl -v --fail http://localhost:${SERVER_PORT} || exit 1

# 如下方法进程号是1
#ENTRYPOINT [ "/usr/local/openjdk-8/bin/java","-jar","-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005","$JAVA_OPTS","/app.jar" ]

# 造成 java进程非1号进程
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -XX:InitialRAMPercentage=75.0 -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom -jar /app.jar"]

