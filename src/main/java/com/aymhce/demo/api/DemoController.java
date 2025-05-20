package com.aymhce.demo.api;

import org.springframework.web.bind.annotation.GetMapping;

public class DemoController {
    
    // This is a simple REST controller that handles HTTP GET requests
    @GetMapping("/")
    public String hello() {
         return "Hello, World!";
    }
    
}
