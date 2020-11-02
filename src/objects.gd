extends Node

const json = """
{
  "tutorial":[
	["Start by adding a static server", "Level0/HUD/Panel/new_StaticServer", "new_StaticServer"],
	["Now point the CNAME record to your server. Server IP is already copied to your clipboard. ","Level0/HUD/Panel/DNS", "dns_change"],
	["You are now ready to receive your first requests. Click Play button to start the month.", "Level0/HUD/MonthControl/new_Wave", "new_month"],
	["You've now started receiving requests from your customers.  If you check the access logs, you can see that you're only able to serve static files for now. You need to create a Dynamic server to serve the API requests.", "Level0/HUD/Panel/new_DynamicServer", "new_DynamicServer"],
	["Dynamic Servers need Databases to store & retrieve data. Create a Database Server.", "Level0/HUD/Panel/new_Database", "new_Database"],
	["Now configure your Dynamic Server to use your new Database. Click on the configuration panel of your new server, go to the Database tab and enter your Database IP.", "last_object", "db_configured"],
	["OK, you are now able to serve API requests, but since your CNAME record is still pointing to your Static Server, you can only serve static files..\n\nYou need to create a Load Balancer, configure the backends and point your DNS record to your new Load Balancer.", "Level0/HUD/Panel/new_LoadBalancer", "new_LoadBalancer"]
  ],
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
