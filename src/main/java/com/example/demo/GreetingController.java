package com.example.demo;

import java.util.Random;
import java.util.concurrent.atomic.AtomicLong;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import io.micrometer.core.instrument.MeterRegistry;

@RestController
public class GreetingController {

  private final AtomicLong id = new AtomicLong(0);
  private final Random random = new Random();
  private static final String GREETING_CALLS_METRIC = "greeting.calls.total";
  private static final String GREETING_ID = "greeting.id"; // a "business" metric
  Logger logger = LoggerFactory.getLogger(GreetingController.class);

  private final MeterRegistry registry;

  public GreetingController(MeterRegistry registry) {
    this.registry = registry;
    registry.gauge(GREETING_ID, id);
  }

  @GetMapping("/hello/{name}")
  @ResponseBody
  public Greeting hello(@PathVariable("name") String name) {
    logger.info("'/hello/{name}' called");
    sleep();
    registry.counter(GREETING_CALLS_METRIC, "action", "hello", "name", name).increment();
    return new Greeting(id.incrementAndGet(), "Hello, " + name);
  }

  @GetMapping("/goodbye/{name}")
  @ResponseBody
  public Greeting goodbye(@PathVariable("name") String name) {
    logger.info("'/goodbye/{name}' called");
    sleep();
    registry.counter(GREETING_CALLS_METRIC, "action", "goodbye", "name", name).increment();
    return new Greeting(id.decrementAndGet(), "Goodbye, " + name);
  }

  public void sleep() {
    double randomSleepSeconds = 0;
    while (randomSleepSeconds <= 0) {
      randomSleepSeconds = random.nextGaussian() + 1.0;
    }
    try {
      Thread.sleep((long) (1000.0 * randomSleepSeconds));
    } catch (InterruptedException e) {
      e.printStackTrace();
    }
  }
}