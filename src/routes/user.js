const router = require("express").Router();
const { admin } = require("../configs/firebase");
const auth = admin.auth();
router.get("/", (req, res) => {
    const { email } = req;
    auth
        .getUserByEmail(email)
        .then((user) => {
            res.status(200).send(user);
        })
        .catch((err) => {
            res.status(404).send({ message: err.message, status: false });
        });
});

router.get("/verifyAdmin", (req, res) => {
    const { email } = req;
    auth
        .getUserByEmail(email)
        .then((user) => {
            auth
                .setCustomUserClaims(user.uid, { admin: true })
                .then((newUser) => {
                    res.status(200).send({ email, newUser, status: true });
                })
                .catch((err) => {
                    es.status(404).send({ message: err.message, status: false });
              });
        })
        .catch((err) => {
          res.status(404).send({ message: err.message, status: false });
        });
});

module.exports = router;
