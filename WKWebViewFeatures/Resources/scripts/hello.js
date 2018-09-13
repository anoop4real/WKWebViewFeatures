function leftTapped() {
    alert('Left');
}
function rightTapped() {
    alert('Right');
}
function changeImagePathWith(path){
    //"http://images.clipartpanda.com/smiley-face-png-1407-smiley-face.png"
    document.getElementById("img").src=path;
}
window.onload=function () { window.webkit.messageHandlers.sizeNotification.postMessage({width: document.width, height: document.body.scrollHeight});};

//window.webkit.messageHandlers.<METHOD NAME>.postMessage(data)
