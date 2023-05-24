# Pre-request Script list of value and randomly set single variable

```
var UploadURLs = 
[
"https://s.com/wp-content/uploads/gravity_forms/1-b1f325d4bbcbbd627f2e84ed938285a0/2000/05/IMG_0450.heic"
,"https://s.com/wp-content/uploads/gravity_forms/1-b1f325d4bbcbbd627f2e84ed938285a0/2000/05/IMG_6932.png"
,"https://s.com/wp-content/uploads/gravity_forms/1-b1f325d4bbcbbd627f2e84ed938285a0/2000/05/EPSON098.PDF"
,"https://s.com/wp-content/uploads/gravity_forms/1-b1f325d4bbcbbd627f2e84ed938285a0/2000/05/IMG_3959.jpeg"
,"https://s.com/wp-content/uploads/gravity_forms/1-b1f325d4bbcbbd627f2e84ed938285a0/2000/05/16846745569934038821441891304961.jpg"
]

pm.environment.set('UploadURLs',UploadURLs);
pm.environment.set("UploadURL", UploadURLs[Math.floor(Math.random() * UploadURLs.length)]);
```

## Set global, environment, and collection variable

![image](https://github.com/RaviRamDhali/programming-procedure/assets/1455413/9fc8fe79-5fe7-4379-b9ee-37cb00dc36c6)

## Usage

![image](https://github.com/RaviRamDhali/programming-procedure/assets/1455413/eabd0645-ec0e-4c25-9496-65e24d8cc2e0)
