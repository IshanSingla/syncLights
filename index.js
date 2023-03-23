// Importing Req
const express = require("express");
const http = require("http");
const socket = require("socket.io");
require("dotenv").config();
const { getIPAddress } = require("./src/utils/getIPAddress");
const { errorHandler } = require("./src/middleware/errorHandler");
const { morganImpl } = require("./src/configs/morgan");

// Setups Servers/ Socket
const app = express();
const server = http.createServer(app);
const io = socket(server);

app
  .use(express.json())
  // .use(morganImpl)
  .use(errorHandler)
  .use(express.urlencoded({ extended: false }))
  .use("/", require("./src/routes"));

var lsts = [];
var data = {};
var users = {};

const update = () => {
  lsts.forEach((id) => {
    if (data[id]["time"] > 0) {
      data[id]["time"]--;
    } else {
      if (data[id]["red"]) {
        data[id]["time"] = 30;
        data[id]["red"] = false;
        data[id]["count"] = 0;
      } else {
        data[id]["time"] = data[id]["redtime"];
        data[id]["red"] = true;
        data[id]["count"] = 0;
      }
    }
  });
};
const joinUpdate = () => {
  lsts.forEach((id, i) => {
    data[id] = {};
    var time = 120 / lsts.length;
    data[id]["redtime"] = time * (lsts.length - 1);
    if (i === 0) {
      data[id]["time"] = time;
      data[id]["red"] = false;
      data[id]["count"] = 0;
    } else {
      data[id]["time"] = time * i;
      data[id]["red"] = true;
      data[id]["count"] = 0;
    }
  });
};

setInterval(() => {
  update();
  var da = JSON.stringify({
    list: lsts,
    lights: data,
  });
  io.emit("users", da);
}, 1000);

io.on("connection", (socket) => {
  try {
    let customId = socket.id;

    // Disconnect
    socket.on("disconnect", function () {
      if (customId.includes("light")) {
        let id = customId.split("_")[1];
        lsts = lsts.filter((datas) => datas != id);
        data[id] = null;
        joinUpdate();
      }
    });

    socket.on("lights", (msg) => {
      if (msg == "1") {
        let id = customId.split("_")[1];
        data[id]["count"]++;
      }
    });
    socket.on("users", (msg) => {});

    // Custom Id
    socket.on("changeId", async (msg) => {
      users[socket.id] = msg;
      customId = msg;
      if (customId.includes("light")) {
        let id = customId.split("_")[1];
        if (!lsts.includes(id)) {
          lsts.push(id);
          data[id] = {
            count: 0,
            time: 30,
            red: false,
            redtime: 90,
          };
          joinUpdate();
        }
      }
    });
  } catch (e) {
    console.log(e);
  }
});

const PORT = Number(process.env.PORT) || 3000;

const text = `
************************************************************
                  Listening on port: ${PORT}
                  http://localhost:${PORT}
                  http://${getIPAddress()}:${PORT}
************************************************************`;

server.listen(PORT, () => {
  console.log(text);
});
