build:
	./mvnw install

run:
	java -jar target/demo-0.0.1-SNAPSHOT.jar

curl-local:
	curl localhost:8080/hello-world

curl-local-actuator:
	curl localhost:8080/actuator

curl-local-prometheus:
	curl localhost:8080/actuator/prometheus

docker-build:
	./mvnw spring-boot:build-image

docker-run:
	docker run -p 8080:8080 demo:0.0.1-SNAPSHOT

docker-push:
	docker tag demo:0.0.1-SNAPSHOT luebken/springboot-prometheus
	docker push luebken/springboot-prometheus

kubectl-apply:
	kubectl apply -f k8s.yaml

kubectl-delete:
	kubectl delete -f k8s.yaml

curl-k8s:
	$(eval MYIP=$(shell kubectl get svc springboot-prometheus -o json |jq -r .status.loadBalancer.ingress[].ip))
	curl $(MYIP):8080/hello-world

tail-logs-k8s:
	kubectl logs -l app=springboot-prometheus -f

curl-k8s-prometheus:
	$(eval MYIP=$(shell kubectl get svc springboot-prometheus -o json |jq -r .status.loadBalancer.ingress[].ip))
	curl $(MYIP):8080/actuator/prometheus
