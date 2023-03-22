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
    </head>
    <body>
        <div class="w-screen h-screen flex items-center bg-teal-600 justify-center">
        <table class="table-auto">
            <thead>
                <tr>
                    <th class="px-4 py-2">NO</th>
                    <th class="px-4 py-2">Circle Name</th>
                    <th class="px-4 py-2">Roadname</th>
                    <th class="px-4 py-2">Link</th>
                </tr>
            </thead>
            <tbody>

            ${data.map((item,index) => {
                return `<tr>
                    <td class="border px-4 py-2">${index+1}</td>
                    <td class="border px-4 py-2">${item.roadCircle}</td>
                    <td class="border px-4 py-2">${item.signalName}</td>
                    <td class="border px-4 py-2"><a target="_blank" href="/IoTDevices/${item.id}">Link</a></td>
                </tr>`;
            }).join("")}
            </tbody>
        </table>
        </div>
    </body>
    </html>
    `;
};

module.exports = {
  getHTML,
  getAllHTML
};
