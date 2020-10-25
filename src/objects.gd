extends Node

const json = """
{
  "entities": {
	"User":{
		"name": "User",
		"monthly_cost":0
	},
	"Request":{
		"name": "Request",
		"monthly_cost": 0
	},
	"StaticServer": {
	  "name": "Static Server",
	  "description": "Serves static content",
	  "monthly_cost": 10,
	  "revenue": 0.8,
	  "load_per_request": 0.1
	},
	"DynamicServer":{
	  "name": "Dynamic Server",
	  "description": "Queries configured databases and returns dynamic content",
	  "monthly_cost": 20,
	  "revenue": 3.2,
	  "load_per_request": 0.12
	},
	"LoadBalancer":{
	  "name": "Load Balancer",
	  "description": "Routes incoming traffic to configured servers",
	  "monthly_cost": 20,
	  "revenue": 0,
	  "load_per_request": 0.025
	},
	"Firewall":{
	  "name": "Firewall",
	  "description": "Stops hackers",
	  "monthly_cost": 80,
	  "revenue": 0,
	  "load_per_request": 0.1
	},
	"Database":{
	  "name": "Database",
	  "description": "Returns to DB queries",
	  "monthly_cost": 40,
	  "revenue": 0,
	  "load_per_request":0.06
	}
	},
  "request_urls": {
	"static": [
		"/assets/index.html",
		"/assets/style.css",
		"/assets/app.js",
		"/assets/main.js",
		"/assets/bg.png",
		"/assets/image.png",
		"/assets/logo.png"
		],
	"dynamic": [
		"/api/add-to-cart",
		"/api/delete",
		"/api/pay",
		"/api/create",
		"/api/login",
		"/api/logout",
		"/api/register"
		]
  	},
  "month":{
	"duration": 30
	},
  "requests":{
	"spread":"1/log(x+1)^2",
	"malicious": 0.01
	},
  "months":{
	"1":{
		"requests":{
			"slow": 20,
			"med": 5,
			"fast": 1,
			"malicious": 0
		},
		"time_between_requests": 0.5
	},
	"2":{
		"requests":{
			"slow": 40,
			"med": 10,
			"fast": 2,
			"malicious": 0
		},
		"time_between_requests": 0.3
	},
	"3":{
		"requests":{
			"slow": 60,
			"med": 20,
			"fast": 5,
			"malicious": 0.01
		},
		"time_between_requests": 0.2
	},
	"4":{
		"requests":{
			"slow": 80,
			"med": 40,
			"fast": 10,
			"malicious": 0.03
		},
		"time_between_requests": 0.15
	},
	"5":{
		"requests":{
			"slow": 80,
			"med": 60,
			"fast": 30,
			"malicious": 0.05
		},
		"time_between_requests": 0.1
	},
	}
}
"""

var objects = JSON.parse(json).result
