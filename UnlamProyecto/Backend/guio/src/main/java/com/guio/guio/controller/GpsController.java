package com.guio.guio.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/gps")
public class GpsController {

	@GetMapping("/location")
	public String getLocation(@RequestParam double latitude, @RequestParam double longitude) {
		// Lógica simple para testear
		return "Received coordinates: Latitude = " + latitude + ", Longitude = " + longitude;
	}
}
