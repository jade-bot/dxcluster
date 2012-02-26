net = require("net")
zmq = require("zmq")
sock = zmq.socket("push")
sock.bindSync "tcp://127.0.0.1:8765"

client = net.connect(8000, "gb7mbc.net", ->
  console.log "connected to DX Cluster"
  client.write "w5isp\r\n"
)

client.on "data", (data) ->
  now = new Date()
  cluster_data = []
  line = data.toString()
  if line.match(/^DX/)
    cluster_data["call"] = /^[a-z0-9\/]*/i.exec(line.substring(6, 16))[0]
    cluster_data["freq"] = line.substring(16, 24).trim()
    cluster_data["dxcall"] = /^[a-z0-9\/]*/i.exec(line.substring(26, 38))[0]
    cluster_data["comment"] = line.substring(39, 69).trim()

    utc_hour = line.substring(70, 72)
    utc_minute = line.substring(72, 74)
    cluster_data["utc"] = new Date(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(), utc_hour, utc_minute)
    sock.send(cluster_data.toString())
    console.log cluster_data

client.on "end", ->
  console.log "client disconnected"

