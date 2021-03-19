build:
	./mvnw install

run:
	java -jar target/demo-0.0.1-SNAPSHOT.jar

docker-build:
	./mvnw spring-boot:build-image

docker-run:
	docker run -p 8080:8080 demo:0.0.1-SNAPSHOT

docker-push:
	docker tag demo:0.0.1-SNAPSHOT luebken/greeting
	docker push luebken/greeting

kubectl-apply:
	kubectl apply -f k8s.yaml

kubectl-delete-all:
	kubectl delete -f k8s.yaml

kubectl-delete-pod:
	kubectl delete pod -l app=greeting

curl-k8s:
	$(eval MYIP=$(shell kubectl get svc greeting -o json |jq -r .status.loadBalancer.ingress[].ip))
	for ((i=1;i<=100;i++)); do \
		curl $(MYIP):8080/hello/world; \
		sleep 1\
    done;

tail-logs-k8s:
	kubectl logs -l app=springboot-prometheus -f

curl-k8s-prometheus:
	$(eval MYIP=$(shell kubectl get svc greeting -o json |jq -r .status.loadBalancer.ingress[].ip))
	curl -s $(MYIP):8080/actuator/prometheus

watch-build:
	cd watch; docker build . -t luebken/watch
	docker push luebken/watch

kubctl-watch-run:
	kubectl run watch-greeting -n greeting --image=luebken/watch
