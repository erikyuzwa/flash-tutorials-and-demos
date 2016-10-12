window.onload = function() {

    var flashvars = {},
    params = {
        wmode: 'direct'
    },
    attributes = {};

    swfobject.embedSWF(
        'example.swf', 
        'flashContainer', 
        '100%', 
        '100%', 
        '11.1.0', 
        'expressInstall.swf',
        flashvars, 
        params, 
        attributes);

};
