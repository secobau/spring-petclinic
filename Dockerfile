FROM alpine/git:latest AS clone

ARG dir=/clone
ARG hostname=github.com
ARG project=spring-petclinic
ARG username=secobau

WORKDIR $dir
RUN git clone https://$hostname/$username/$project

###

FROM maven:alpine AS build

ARG dir_old=/clone
ARG dir=/build
ARG project=spring-petclinic

WORKDIR $dir
COPY --from=clone $dir_old/$project . 
RUN mvn install && mv target/$project-*.jar target/$project.jar

###

FROM openjdk:jre-alpine AS production

ARG dir_old=/build/target
ARG dir=/app
ARG project=spring-petclinic

WORKDIR $dir
COPY --from=build $dir_old/$project.jar . 

ENTRYPOINT ["java","-jar"]
CMD ["spring-petclinic.jar"]
