var zmq = require('zmq');
var sock = zmq.socket('pull');

sock.connect('tcp://127.0.0.1:8765');
console.log('Worker connected to port 8765');

sock.on('message', function(msg){
  console.log('work: %s', msg.toString());
});

