FROM openjdk:8
EXPOSE 8080
ADD path/springboot-web-dockerimage.jar springboot-web-dockerimage.jar 
ENTRYPOINT ["java","-jar","/springboot-web-dockerimage.jar"]