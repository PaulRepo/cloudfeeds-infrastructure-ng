# Plant UML

Plant UML is a text to image tool which is being used in documentation. The soft copies of these documents can be found in the [docs directory](../../docs/plantuml). The rendering server can be easily started with a docker command.

##  Requirements

[Docker](https://docs.docker.com/get-docker/)

## Rendering Server

As mentioned in the [dockerhub](https://hub.docker.com/r/plantuml/plantuml-server), you can run Plantuml with jetty or tomcat containers.

```bash
docker run -d -p 8080:8080 plantuml/plantuml-server:jetty
docker run -d -p 8080:8080 plantuml/plantuml-server:tomcat
```
