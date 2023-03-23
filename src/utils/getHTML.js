const getHTML = (id) => {
  return `<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SyncLights</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" media="screen" href="https://fontlibrary.org//face/segment7" type="text/css"/>
    </head>
    <body>
        <div class="w-screen h-screen flex items-center bg-teal-600 justify-center">
            <div class="w-full z-5 bg-green-700 h-1/5 rounded-t-full bottom-0 absolute"></div>
            <div class="rounded-full bg-black h-16 w-16 absolute bottom-5 flex items-center justify-center text-white"><button onclick="changeId()" class="text-6xl flex items-center justify-center mb-2">+</button></div>
            <div class="  h-screen w-2/5 flex flex-col items-center justify-center">
                <div class="h-3 w-10  bg-black"></div>
                <div id="update" class="bg-black w-28 rounded-xl h-2/5 flex flex-col items-center justify-evenly">
                    <div class="h-16 w-16 rounded-full bg-red-900"></div>
                    <div class="h-16 w-16 rounded-full bg-yellow-900"></div>
                    <div class="h-16 w-16 rounded-full bg-green-900"></div>
                </div>
                <div class="h-5 w-10 bg-black"></div>
                <div id="time" style="font-family: 'Segment7Standard'" class="h-24  w-28 bg-black text-red-500 flex items-center justify-center text-7xl ">
                    00
                </div>
                <div class="w-10  bg-black h-2/6"></div>
            </div>
        </div>
    </body>
    <script src="/socket.io/socket.io.js"></script>
    <script>
        var id="${id}";
        try {
            var socket = io();
        } catch (e) {
            alert("not able to connect to sockets");
        }
        function changeId() {
            socket.emit("lights", '1');
        }
        socket.on("connect", () => {
            socket.emit("changeId", 'light_'+id);
        });
        socket.on("users", (msg) => {
            var data=JSON.parse(msg)
            var colour=data.lights[id].red;
            console.log(JSON.parse(msg));
            document.getElementById("update").innerHTML = '<div class="h-16 w-16 rounded-full bg-red-'+(colour?"700":"900")+'"></div><div class="h-16 w-16 rounded-full bg-yellow-900"></div><div class="h-16 w-16 rounded-full bg-green-'+(colour?"900":"500")+'"></div>';
            document.getElementById("time").innerHTML = data.lights[id].time;
        });
    </script>
    </html>
    `;
};

const getAllHTML = (data) => {
  return `<!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>SyncLights</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" media="screen" href="https://fontlibrary.org//face/segment7" type="text/css"/>
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
                screens:{
                  'xxs':'300px',
                  'xs':'390px',
                'sm': '640px',
                // => @media (min-width: 640px) { ... }
            
                'md': '768px',
                // => @media (min-width: 768px) { ... }
            
                'lg': '1024px',
                // => @media (min-width: 1024px) { ... }
            
                'xl': '1280px',
                // => @media (min-width: 1280px) { ... }
            
                '2xl': '1536px',
                // => @media (min-width: 1536px) { ... }
              },
                extend: {
                  fontFamily: {
                    headline: ["Poppins","sans-serif"],
                  },
                  colors: {
                    mainColor: "#23b574",
                    primary:"#f4dc00"
                    
                  },
                  spacing: {
                    '13': '3.25rem',
                    '15': '3.75rem',
                    '84':'352px',
                    '128': '32rem',
                    '144': '35rem',
                  }
                },
              },
        }
    </script>
    <body class="bg-mainColor relative h-screen w-screen">
    <div class="absolute top-0 w-screen z-[-1]">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="#f4dc00" fill-opacity="1" d="M0,224L26.7,213.3C53.3,203,107,181,160,170.7C213.3,160,267,160,320,160C373.3,160,427,160,480,149.3C533.3,139,587,117,640,122.7C693.3,128,747,160,800,165.3C853.3,171,907,149,960,149.3C1013.3,149,1067,171,1120,170.7C1173.3,171,1227,149,1280,138.7C1333.3,128,1387,128,1413,128L1440,128L1440,0L1413.3,0C1386.7,0,1333,0,1280,0C1226.7,0,1173,0,1120,0C1066.7,0,1013,0,960,0C906.7,0,853,0,800,0C746.7,0,693,0,640,0C586.7,0,533,0,480,0C426.7,0,373,0,320,0C266.7,0,213,0,160,0C106.7,0,53,0,27,0L0,0Z"></path></svg>
    </div>
    
    <header class="flex items-center justify-between w-screen h-[10%]">
      <nav class="flex items-center justify-center  w-full">
        <div class="flex items-center justify-center p-2 w-full">
          <div class="flex items-center justify-center p-2 max-w-7xl w-full">
            <div class="flex items-center justify-between w-full">
                 <div class="flex items-center justify-center ">
                  <img src="https://raw.githubusercontent.com/IshanSinglaHackathon/syncLights/FlutterFrontEnd/assets/logo/logo.png" class="h-12 w-12" alt="logo" />
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
      <div class="w-full mb-8 overflow-hidden rounded-lg shadow-lg">
        <div class="w-full overflow-x-auto">
          <table class="w-full">
            <thead>
              <tr class="text-md font-semibold tracking-wide text-left text-gray-900 bg-gray-100 uppercase border-b border-gray-600">
                <th class="px-4 py-3">No</th>
                <th class="px-4 py-3">Circle Name</th>
                <th class="px-4 py-3">Roadname</th>
                <th class="px-4 py-3">Link</th>
              </tr>
            </thead>
            <tbody class="bg-white">

            ${data
              .map((item, index) => {
                return `<tr "text-gray-700">
                    <td class="px-4 py-3 border">${index + 1}</td>
                    <td class="px-4 py-3 border">${item.roadCircle}</td>
                    <td class="border px-4 py-3 text-sm ">${item.signalName}</td>
                    <td class="border px-4 py-3 text-sm "><a class="px-2 py-1 font-semibold leading-tight text-green-700 bg-green-100 hover:bg-green-300 rounded-sm" target="_blank" href="/IoTDevices/${
                      item.id
                    }">Link</a></td>
                </tr>`;
              })
              .join("")}
            </tbody>
            </table>
            </div>
          </div>
        </section>
        <div class="absolute bottom-0 w-screen z-[-1]">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="#f4dc00" fill-opacity="1" d="M0,224L26.7,213.3C53.3,203,107,181,160,170.7C213.3,160,267,160,320,160C373.3,160,427,160,480,149.3C533.3,139,587,117,640,122.7C693.3,128,747,160,800,165.3C853.3,171,907,149,960,149.3C1013.3,149,1067,171,1120,170.7C1173.3,171,1227,149,1280,138.7C1333.3,128,1387,128,1413,128L1440,128L1440,320L1413.3,320C1386.7,320,1333,320,1280,320C1226.7,320,1173,320,1120,320C1066.7,320,1013,320,960,320C906.7,320,853,320,800,320C746.7,320,693,320,640,320C586.7,320,533,320,480,320C426.7,320,373,320,320,320C266.7,320,213,320,160,320C106.7,320,53,320,27,320L0,320Z"></path></svg>
        </div></div>
       </main>
    </body>
    </html>
    `;
};

module.exports = {
  getHTML,
  getAllHTML,
};
