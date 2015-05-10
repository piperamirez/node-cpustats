var sqlite3 = require('sqlite3').verbose();
var db = new sqlite3.Database('stats.sqlite');
 
var express = require('express');
var restapi = express();

restapi.all('*', function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
 });

restapi.get('/data', function(req, res){
	var data = [];
	db.each("select * from (select * from stats order by timestamp desc limit 10080) order by timestamp asc", function(err, row) {
		data.push({
			"cpu_temp" : row.cpu_temp,
			"cpu_fan_speed" : row.cpu_fan_speed,
			"cpu_usage_user" : row.cpu_usage_user,
			"cpu_usage_sys" : row.cpu_usage_sys,
			"cpu_usage_idle" : row.cpu_usage_idle,
			"mem_usage_wired" : row.mem_usage_wired,
			"mem_usage_active" : row.mem_usage_active,
			"mem_usage_inactive" : row.mem_usage_inactive,
			"mem_usage_used" : row.mem_usage_used,
			"mem_usage_free" : row.mem_usage_free,
			"timestamp" : row.timestamp 
		});
    }, function() {
    	res.json(data);
    });
});
  
restapi.listen(3000);
