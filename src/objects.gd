extends Node

const json = """
{
  "entities": {
	"User":{
		"name": "User",
		"initial_cost":0
	},
	"Request":{
		"name": "Request",
		"initial_cost": 0
	},
	"StaticServer": {
	  "name": "Static Server",
	  "description": "Serves static content",
	  "initial_cost": 20,
	  "revenue": 1,
	  "load_per_request": 0.1
	},
	"DynamicServer":{
	  "name": "Dynamic Server",
	  "description": "Queries configured databases and returns dynamic content",
	  "initial_cost": 100,
	  "revenue": 5,
	  "load_per_request": 0.12
	},
	"LoadBalancer":{
	  "name": "Load Balancer",
	  "description": "Routes incoming traffic to configured servers",
	  "initial_cost": 100,
	  "revenue": 0,
	  "load_per_request": 0.025
	},
	"Database":{
	  "name": "Database",
	  "description": "Returns to DB queries",
	  "initial_cost": 200,
	  "revenue": 0,
	  "load_per_request":0.2
	}
  },
  "waves":{
	"1":{
		"requests":{
			"slow": 20,
			"med": 5,
			"fast": 1
		},
		"time_between_requests": 0.5
	},
	"2":{
		"requests":{
			"slow": 40,
			"med": 10,
			"fast": 2
		},
		"time_between_requests": 0.3
	},
	"3":{
		"requests":{
			"slow": 60,
			"med": 20,
			"fast": 5
		},
		"time_between_requests": 0.2
	},
	"4":{
		"requests":{
			"slow": 80,
			"med": 40,
			"fast": 10
		},
		"time_between_requests": 0.15
	},
	"5":{
		"requests":{
			"slow": 80,
			"med": 60,
			"fast": 30
		},
		"time_between_requests": 0.1
	},
  }
}
"""

var objects = JSON.parse(json).result
