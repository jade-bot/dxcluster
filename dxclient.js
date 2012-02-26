var net = require('net');

var client = net.connect(8000, 'gb7mbc.net', function() {
  console.log('client connected');
  client.write('w5isp\r\n');
});

var raw_cluster_data;
var cluster_data = [];

client.on('data', function(data) {

  line = data.toString();
  if (line.match(/^DX/)) {
    cluster_data['call'] = /^[a-z0-9\/]*/i.exec(line.substring(6,16))[0];
    cluster_data['freq'] = /^[0-9\.]*/.exec(line.substring(16,24))[0];
    cluster_data['dxcall'] = line.substring(26,38);
    cluster_data['comment'] = line.substring(39,69);
    cluster_data['utc'] = line.substring(70,74);
    console.log(cluster_data);
  }
  //client.end();
});

client.on('end', function() {
  console.log('client disconnected');
});

