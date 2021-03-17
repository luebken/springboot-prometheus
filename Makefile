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

# Curl the custom SBP metrics
curl-local-prometheus-sbp:
	curl localhost:8080/actuator/prometheus |grep sbp

docker-build:
	./mvnw spring-boot:build-image

docker-run:
	docker run -p 8080:8080 demo:0.0.1-SNAPSHOT

docker-push: docker-build
	docker tag demo:0.0.1-SNAPSHOT luebken/springboot-prometheus
	docker push luebken/springboot-prometheus

kubectl-apply:
	kubectl apply -f k8s.yaml

kubectl-delete-all:
	kubectl delete -f k8s.yaml

kubectl-delete-pod:
	kubectl delete pod -l app=springboot-prometheus

curl-k8s:
	$(eval MYIP=$(shell kubectl get svc springboot-prometheus -o json |jq -r .status.loadBalancer.ingress[].ip))
	for ((i=1;i<=100;i++)); do \
		curl $(MYIP):8080/hello-world; \
    done;

tail-logs-k8s:
	kubectl logs -l app=springboot-prometheus -f

curl-k8s-prometheus:
	$(eval MYIP=$(shell kubectl get svc springboot-prometheus -o json |jq -r .status.loadBalancer.ingress[].ip))
	curl -s $(MYIP):8080/actuator/prometheus
