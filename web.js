var app = require('express').createServer();
var socket = require('socket.io');
var zmq = require('zmq');
var zmqsock = zmq.socket('pull');

zmqsock.connect('tcp://127.0.0.1:8765');
console.log('Worker connected to port 8765');

zmqsock.on('message', function(msg){
  console.log('work: %s', msg.toString());
});

app.get('/', function(req, res){
});

app.listen(3000);


