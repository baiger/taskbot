var mysql = require('mysql');
var connection = mysql.createConnection({
    host     : process.env.DB_HOST,
    user     : process.env.DB_USER,
    password : process.env.DB_PASS,
    database : process.env.DB_NAME
});

exports.addList = function(name, description, server, user)
exports.addTask = function(name, description, server, user)
