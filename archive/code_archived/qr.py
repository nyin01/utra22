import qrcode

img = qrcode.make("https://github.com/nyin01/utra22")
img.save("repoqr.jpg")
