# First Stage: Build the application
FROM maven:3.8.5-openjdk-17-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Second Stage: Create the final image with only the necessary files
FROM openjdk:17-jdk-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/spring-petclinic-*.jar spring-petclinic.jar

# Expose the application port
EXPOSE 8080

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "spring-petclinic.jar"]
