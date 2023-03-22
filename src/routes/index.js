const { getHTML, getAllHTML } = require("../utils/getHTML");
const { firebaseAuth } = require("../middleware/firebaseAuth");
const router = require("express").Router();
const { admin } = require("../configs/firebase");

router.get("/", (req, res) => {
  admin
    .firestore()
    .collection("trafficLights")
    .get()
    .then((snapshot) => {
      const data = snapshot.docs.map((doc) => {
        return { ...doc.data(), id: doc.id };
      });
      res.status(200).send(getAllHTML(data));
    });

  // res.redirect("/IoTDevices/7NaBu4XYlCap28WYIByz");
});

router.get("/IoTDevices/:id", (req, res) => {
  const { id } = req.params;
  res.status(200).send(getHTML(id));
});

router.use(
  "/user/:email",
  (req, res, next) => {
    req.email = req.params.email;
    next();
  },
  firebaseAuth,
  require("./user")
);

router.use("*", (req, res) => {
  res.status(404).json({ message: "404 Error", route: req.originalUrl });
});

module.exports = router;
