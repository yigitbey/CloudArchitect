extends Node

const json = """
{
  "servers": {
	"StaticServer": {
	  "name": "Static Server",
	  "description": "Serves static content",
	  "initial_cost": 20,
	  "revenue": 1
	},
	"DynamicServer":{
	  "name": "Dynamic Server",
	  "description": "Queries configured databases and returns dynamic content",
	  "initial_cost": 100,
	  "revenue": 5
	},
	"LoadBalancer":{
	  "name": "Load Balancer",
	  "description": "Routes incoming traffic to configured servers",
	  "initial_cost": 100,
	  "revenue": 0
	},
	"Database":{
	  "name": "Database",
	  "description": "Returns to DB queries",
	  "initial_cost": 200,
	  "revenue": 0
	}
  }
}
"""

var objects = JSON.parse(json).result
