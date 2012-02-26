var client, cluster_data, net;

net = require("net");

client = net.connect(8000, "gb7mbc.net", function() {
  console.log("client connected");
  return client.write("w5isp\r\n");
});

cluster_data = [];

client.on("data", function(data) {
  var line, now, utc_hour, utc_minute;
  now = new Date();
  line = data.toString();
  if (line.match(/^DX/)) {
    cluster_data["call"] = /^[a-z0-9\/]*/i.exec(line.substring(6, 16))[0];
    cluster_data["freq"] = line.substring(16, 24).trim();
    cluster_data["dxcall"] = /^[a-z0-9\/]*/i.exec(line.substring(26, 38))[0];
    cluster_data["comment"] = line.substring(39, 69).trim();
    utc_hour = line.substring(70, 72);
    utc_minute = line.substring(72, 74);
    cluster_data["utc"] = new Date(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), utc_hour, utc_minute);
    return console.log(cluster_data);
  }
});

client.on("end", function() {
  return console.log("client disconnected");
});
