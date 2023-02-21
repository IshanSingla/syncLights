const morgan = require("morgan");

morgan.token("id", (req) => req.id);

const logFormat =
  ":date[iso] :remote-addr :method :url :status :res[content-length] - :response-time ms";
const morganImpl = morgan(logFormat);

module.exports = {
  morganImpl,
};