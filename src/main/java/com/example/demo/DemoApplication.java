package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;
import io.micrometer.core.instrument.Metrics;


@SpringBootApplication
public class DemoApplication {

	private static Logger logger = LoggerFactory.getLogger(DemoApplication.class);

	public static void main(String[] args) {
		logger.info("DemoApplication.main");

		Metrics.addRegistry(new SimpleMeterRegistry());

		//TODO make this a global counter
		Metrics.counter("mdl.test.objects.instance").increment();

		SpringApplication.run(DemoApplication.class, args);
	}

}
