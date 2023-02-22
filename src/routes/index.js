const { getHTML } = require("../utils/getHTML");
const { firebaseAuth } = require("../middleware/firebaseAuth");
const router = require("express").Router();

router.get("/", (req, res) => {
    res.redirect("/IoTDevices/7NaBu4XYlCap28WYIByz");
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