const { admin } = require("../configs/firebase");

async function firebaseAuth(req, res, next) {
    if (!req.headers || !req.headers["authorization"]) {
        return res
            .status(401)
            .json({ message: "Unauthorized", status: "Token not found" });
    }
    const authHeader = req.headers["authorization"];
    const token = authHeader && authHeader.split(" ")[1];
    if (!token || token === null) {
        return res
            .status(401)
            .json({ message: "Unauthorized", status: "Token not found" });
    }
    let firebaseUser = await admin.auth().verifyIdToken(token);
    if (
        !(
            firebaseUser &&
            firebaseUser.uid &&
            firebaseUser.customClaims &&
            firebaseUser.customClaims.admin
        )
    ) {
        return res
            .status(401)
            .json({ message: "Unauthorized", status: "User not found in firebase" });
    }
    req.user = firebaseUser;
    next();
}

module.exports = {
  firebaseAuth,
};
