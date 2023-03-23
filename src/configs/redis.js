const { Client } = require("redis-om");

const client = new Client();

const connect = async () => {
  if (!client.isOpen()) {
    client
      .open(
        "redis://default:Y47dCB1FEkQK5w4sdJ4xJJGe9tYh7EfW@redis-10551.c259.us-central1-2.gce.cloud.redislabs.com:10551"
      )
      .catch((err) => {
        console.log(err);
      });
  }
  return client;
};

const set = async (key = "", value = { count: 0, active: false }) => {
  connect();
  let data = await client.jsonget(key);
  if (data) {
    throw new Error("Key already exists");
  } else {
    client.jsonset(key, JSON.stringify(value));
  }
  client.close();
};
const get = async (key = "") => {
  connect();
  let data = JSON.parse(await client.jsonget(key));
  client.close();
  return data;
};

const update = async (
  key = "",
) => {
  connect();
  let data = JSON.parse(await client.jsonget(key));
  if (data) {
    client.jsonset(key, JSON.stringify({active: !data["active"], count:0}));
  } else {
    throw new Error("Key does not exists");
  }
  client.close();
};

const incriment = async (key = "", field = "") => {
  connect();
  let data = JSON.parse(await client.jsonget(key));
  if (data) {
    data[field] = data[field] + 1;
    client.jsonset(key, JSON.stringify(data));
  } else {
    throw new Error("Key does not exists");
  }
  client.close();
};

const reset = async (key = "") => {
  connect();
  let data = JSON.parse(await client.jsonget(key));
  if (data) {
    data["count"] = 0;
    client.jsonset(key, JSON.stringify(data));
  } else {
    throw new Error("Key does not exists");
  }
  client.close();
};

module.exports = {
  reset,
  connect,
  set,
  get,
  update,
  incriment,
};
