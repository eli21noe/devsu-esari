FROM openjdk:17-alpine

ENV SPRING_PROFILES_ACTIVE=prod
ENV PORT=8080

#Creacion de un usuario no root para la ejecucion del conteneodr
#RUN groupadd -r spring && useradd -r -g spring spring
#USER spring:spring

RUN mkdir /app

COPY ./target/demo-0.0.1.jar app.jar

# Define un health check para comprobar la salud de la aplicación
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 CMD curl --fail http://localhost:$PORT/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar" ]
