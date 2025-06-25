package com.aymhce.demo.api;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
public class DemoController {

    // This is a simple REST controller that handles HTTP GET requests
    @GetMapping("/")
    public String hello() {
         return "Page accueil : hello, MAIF VIE World!";
    }
    
    @GetMapping("/api/hello2")
    public String hello2() {
         return "Hello, MAIF VIE World!";
    }
}
