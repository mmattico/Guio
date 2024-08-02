package com.guio.guio.controller;

import org.springframework.web.bind.annotation.*;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/gps")
public class GpsController {

	@GetMapping("/location")
	public String getLocation(@RequestParam double latitude, @RequestParam double longitude) {
		// Lógica simple para testear
		return "Received coordinates: Latitude = " + latitude + ", Longitude = " + longitude;
	}
}
