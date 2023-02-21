const router = require("express").Router();

router.get("/", (req, res) => {
  res.status(200).render("index");
});

router.use("*", (req, res) => {
  res.status(404).json({ message: "404 Error", route: req.originalUrl });
});
module.exports = router;
