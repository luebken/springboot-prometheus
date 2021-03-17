package com.example.demo;

import java.util.concurrent.atomic.AtomicLong;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import io.micrometer.core.annotation.Timed;
import io.micrometer.core.instrument.Counter;
import io.micrometer.core.instrument.Metrics;
import io.micrometer.core.instrument.simple.SimpleMeterRegistry;

@Controller
@Timed
public class HelloWorldController {

  private static final String template = "Hello, %s!";
  private final AtomicLong counter = new AtomicLong();
  Logger logger = LoggerFactory.getLogger(HelloWorldController.class);

  @GetMapping("/hello-world")
  @ResponseBody
  @Timed(extraTags = { "service", "sbp" })
  public Greeting sayHello(@RequestParam(name = "name", required = false, defaultValue = "Stranger") String name) {
    logger.info("Hello from HelloWorldController");

    var registry = new SimpleMeterRegistry();
    Metrics.addRegistry(registry);
    Counter.builder("sbp.greeting.id").description("The current greeting id").tags("service", "spb").register(registry);
    Metrics.counter("sbp.greeting.id").increment();
    return new Greeting(counter.incrementAndGet(), String.format(template, name));
  }

}