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
  .use(morganImpl)
  .use(errorHandler)
  .use(express.urlencoded({ extended: false }))
  .use("/", require("./src/routes"));

var lsts = [];
var data = {};
var users = {};

setInterval(() => {
  io.emit(
    "users",
    JSON.stringify({
      list: lsts,
      lights: data,
    })
  );
}, 1000);

io.on("connection", (socket) => {
  try {
    let customId = socket.id;
    // console.log(socket.id, "has joined");

    // Disconnect
    socket.on("disconnect", function () {
      // console.log(customId, "has left");
      if (customId.includes("light")) {
        let id = customId.split("_")[1];
        lsts = lsts.filter((datas) => datas != id);
        data[id] = null;
      }
    });

    socket.on("lights", (msg) => {
      if (msg == "1") {
        let id = customId.split("_")[1];
        data[id]["count"]++;
      }
    });
    socket.on("users", (msg) => {
      // console.log(msg);
    });

    // Custom Id
    socket.on("changeId", (msg) => {
      users[socket.id] = msg;
      customId = msg;
      // console.log(customId, "is new id");
      if (customId.includes("light")) {
        let id = customId.split("_")[1];
        if (!lsts.includes(id)) {
          lsts.push(id);
          data[id] = {
            count: 0,
            time: 30,
            red: false,
          };
          setInterval(() => {
            if (socket.connected) {
              if (data[id]["time"] > 0) {
                data[id]["time"]--;
              } else {
                if (data[id]["red"]) {
                  data[id]["time"] = 30;
                  data[id]["red"] = false;
                  data[id]["count"] = 0;
                } else {
                  data[id]["time"] = 90;
                  data[id]["red"] = true;
                  data[id]["count"] = 0;
                  
                }
              }
            }
          }, 1000);
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
