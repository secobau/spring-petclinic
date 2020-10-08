FROM alpine/git:latest AS clone
ARG hostname=github.com
ARG project=spring-petclinic
ARG username=secobau
WORKDIR /clone-folder
RUN git clone https://$hostname/$username/$project

FROM maven:alpine AS build
WORKDIR /app2
COPY --from=clone /app1/spring-petclinic . 
RUN mvn install && mv target/spring-petclinic-*.jar target/spring-petclinic.jar

FROM openjdk:jre-alpine AS production
WORKDIR /app3
COPY --from=build /app2/target/spring-petclinic.jar .
ENTRYPOINT ["java","-jar"]
CMD ["spring-petclinic.jar"]

# COMMENT
