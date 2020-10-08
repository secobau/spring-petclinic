ARG image=alpine/git
ARG release=latest
ARG from=clone

FROM $image:$release AS $from

ARG dir=clone-folder
ARG hostname=github.com
ARG project=spring-petclinic
ARG username=secobau

WORKDIR /$dir
RUN git clone https://$hostname/$username/$project

###

ARG image=maven
ARG release=alpine
ARG from=build

FROM $image:$release AS $from

ARG from_old=clone
ARG dir_old=clone-folder
ARG dir=build-folder
ARG project=spring-petclinic

WORKDIR /$dir
COPY --from=$from_old /$dir_old/$project . 
RUN mvn install && mv target/$project-*.jar target/$project.jar

###

ARG image=openjdk
ARG release=jre-alpine
ARG from=production

FROM $image:$release AS $from

ARG from_old=build
ARG dir_old=build-folder/target
ARG dir=production-folder
ARG project=spring-petclinic.jar

WORKDIR /$dir
COPY --from=$from_old /$dir_old/$project . 
ENTRYPOINT ["java","-jar"]
#CMD ["$project"]
CMD $project
