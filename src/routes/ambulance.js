const { set, incriment, get, reset, update } = require("../configs/redis");

const router = require("express").Router();

router.get("/", (req, res) => {
  res.status(200).send(`<!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>SyncLights</title>
      <script src="https://cdn.tailwindcss.com"></script>
      <link
        rel="stylesheet"
        media="screen"
        href="https://fontlibrary.org//face/segment7"
        type="text/css"
      />
      <link
        rel="stylesheet"
        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css"
        integrity="sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A=="
        crossorigin="anonymous"
        referrerpolicy="no-referrer"
      />
    </head>
    <script>
      tailwind.config = {
        theme: {
          screens: {
            xxs: "300px",
            xs: "390px",
            sm: "640px",
            // => @media (min-width: 640px) { ... }
  
            md: "768px",
            // => @media (min-width: 768px) { ... }
  
            lg: "1024px",
            // => @media (min-width: 1024px) { ... }
  
            xl: "1280px",
            // => @media (min-width: 1280px) { ... }
  
            "2xl": "1536px",
            // => @media (min-width: 1536px) { ... }
          },
          extend: {
            fontFamily: {
              headline: ["Poppins", "sans-serif"],
            },
            colors: {
              mainColor: "#23b574",
              primary: "#f4dc00",
            },
            spacing: {
              13: "3.25rem",
              15: "3.75rem",
              84: "352px",
              128: "32rem",
              144: "35rem",
            },
          },
        },
      };
    </script>
    <body class="bg-mainColor relative h-screen w-screen">
      <div class="absolute top-0 w-screen z-[-1]">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
          <path
            fill="#f4dc00"
            fill-opacity="1"
            d="M0,224L26.7,213.3C53.3,203,107,181,160,170.7C213.3,160,267,160,320,160C373.3,160,427,160,480,149.3C533.3,139,587,117,640,122.7C693.3,128,747,160,800,165.3C853.3,171,907,149,960,149.3C1013.3,149,1067,171,1120,170.7C1173.3,171,1227,149,1280,138.7C1333.3,128,1387,128,1413,128L1440,128L1440,0L1413.3,0C1386.7,0,1333,0,1280,0C1226.7,0,1173,0,1120,0C1066.7,0,1013,0,960,0C906.7,0,853,0,800,0C746.7,0,693,0,640,0C586.7,0,533,0,480,0C426.7,0,373,0,320,0C266.7,0,213,0,160,0C106.7,0,53,0,27,0L0,0Z"
          ></path>
        </svg>
      </div>
  
      <header class="flex items-center justify-between w-screen h-[10%]">
        <nav class="flex items-center justify-center w-full">
          <div class="flex items-center justify-center p-2 w-full">
            <div class="flex items-center justify-center p-2 max-w-7xl w-full">
              <div class="flex items-center justify-between w-full">
                <div class="flex items-center justify-center">
                  <img
                    src="https://raw.githubusercontent.com/IshanSinglaHackathon/syncLights/FlutterFrontEnd/assets/logo/logo.png"
                    class="h-12 w-12"
                    alt="logo"
                  />
                </div>
                <div class="flex items-center justify-center">
                  <ul class="flex items-center justify-center gap-6 font-black">
                    <li>Home</li>
                    <li>About</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </nav>
      </header>
      <main class="relative h-[90%]">
        <section class="container mx-auto p-6 max-w-7xl">
          <div class="w-full mb-8 overflow-hidden rounded-lg shadow-lg flex flex-col">
            <button id="check"  class="p-6 bg-green-300 hover:bg-green-500" onclick="check()">Start/ Stop</button>
            <button id="check" class="p-6 bg-green-300 hover:bg-green-500" onclick="incriment()">incriment</button>
            <button id="check" class="p-6 bg-green-300 hover:bg-green-500" onclick="reset()">Reset</button>
          </div>
        </section>
        <div class="absolute bottom-0 w-screen z-[-1]">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320">
            <path
              fill="#f4dc00"
              fill-opacity="1"
              d="M0,224L26.7,213.3C53.3,203,107,181,160,170.7C213.3,160,267,160,320,160C373.3,160,427,160,480,149.3C533.3,139,587,117,640,122.7C693.3,128,747,160,800,165.3C853.3,171,907,149,960,149.3C1013.3,149,1067,171,1120,170.7C1173.3,171,1227,149,1280,138.7C1333.3,128,1387,128,1413,128L1440,128L1440,320L1413.3,320C1386.7,320,1333,320,1280,320C1226.7,320,1173,320,1120,320C1066.7,320,1013,320,960,320C906.7,320,853,320,800,320C746.7,320,693,320,640,320C586.7,320,533,320,480,320C426.7,320,373,320,320,320C266.7,320,213,320,160,320C106.7,320,53,320,27,320L0,320Z"
            ></path>
          </svg>
        </div>
      </main>
    </body>
    <script>
      const check = () => {
        console.log("check");
        fetch("/ambulance/update", { method: "GET" })
          .then((res) => {
            alert("done");
          })
          .catch((err) => {
            alert(err.message);
          });
      };
      const incriment = () => {
        console.log("check");
        fetch("/ambulance/incriment", { method: "GET" })
          .then((res) => {
            alert("done");
          })
          .catch((err) => {
            alert(err.message);
          });
      };
      const reset = () => {
        console.log("check");
        fetch("/ambulance/reset", { method: "GET" })
          .then((res) => {
            alert("done");
          })
          .catch((err) => {
            alert(err.message);
          });
      };
    </script>
  </html>
  `);
});

router.get("/get", (req, res) => {
  get("ambulance")
    .then((data) => {
      res.status(200).json(data);
    })
    .catch((err) => {
      res.status(500).json(err);
    });
});
router.get("/update", (req, res) => {
  update("ambulance")
    .then(() => {
      res.status(200).json({ message: "Ambulance Route" });
    })
    .catch((err) => {
      res.status(500).json(err);
    });
});

router.get("/incriment", (req, res) => {
  incriment("ambulance", "count")
    .then(() => {
      res.status(200).json({ message: "Ambulance Route" });
    })
    .catch((err) => {
      res.status(500).json(err);
    });
});

router.get("/reset", (req, res) => {
  reset("ambulance")
    .then(() => {
      res.status(200).json({ message: "Ambulance Route" });
    })
    .catch((err) => {
      res.status(500).json(err);
    });
});

router.get("/set", (req, res) => {
  set("ambulance", { count: 0, active: false })
    .then(() => {
      res.status(200).json({ message: "Ambulance Route" });
    })
    .catch((err) => {
      res.status(500).json(err);
    });
});

module.exports = router;
