package com.aymhce.demo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles({"test", "h2"})
class DemoApplicationTests {

	@Test
	void contextLoads() {
	}

}
