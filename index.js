// Importing Req
const express = require("express");
const http = require("http");
const socket = require("socket.io");
const { stringify } = require("querystring");
require("dotenv").config();
const path = require("path");

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
  .set("view engine", "ejs")
  .use(express.static("public"))
  .use(express.urlencoded({ extended: false }))
  .set("views", path.join(__dirname, "views"))
  .set("public", path.join(__dirname, "public"))
  .use("/", require("./src/routes"));

var lsts = [];
var data = {};

io.on("connection", (socket) => {
  console.log("connected");
  console.log(socket.id, "has joined");
  if (socket.id.includes("user")) {
    let dat = {
      list: lsts,
      lights: data,
    };
    io.emit("users", stringify(dat));
    // check user
  }
  if (socket.id.includes("light")) {
    let id = socket.id.split("_")[1];
    lsts.push(id);
    data[id] = {
      count: 0,
      time: 0,
    };
  }
  socket.on("lights", (msg) => {
    console.log(msg);
  });
  socket.on("users", (msg) => {
    console.log(msg);
  });
  socket.on("disconnect", function () {
    // Emits a status message to the connected room when a socket client is disconnected
    if (socket.id.includes("lights")) {
      let id = socket.id.split("_")[1];
      let index = lsts.indexOf(id);
      lsts = lsts.splice(index, 1);
      data[id] = null;
    }
  });

  // Testing
  socket.on('chat message', (msg) => {
    console.log(msg);
  io.emit('chat message', msg);
});
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
