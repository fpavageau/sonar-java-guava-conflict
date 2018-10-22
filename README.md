# Reproducer for a SonarQube bug involving SonarJava 5.8

## Prerequisites

- Docker
- JDK 10

## Set up

Build the Docker image of SonarQube with the set of plugins which conflict:

    docker build -t sonarqube:java5.8-conflict .

Run a SonarQube container:

    docker run --rm -p 9000:9000 --name sonarqube sonarqube:java5.8-conflict

## Run the analysis on the project

Don't forget to use JDK 10 (`targetCompatibility` is set so it won't build otherwise).

    ./gradlew sonarqube --stacktrace

## Stop the SonarQube container

    docker stop sonarqube

-----

Licensed under the LGPL 3.
