({
    displayTime : function(cmp) {
        var offsets = cmp.get("v.offsets");
        var offset = offsets[0];
        var time = new Date();
        var utc = time.getTime() + (time.getTimezoneOffset() * 60000);
        var clientTime = new Date(utc + (3600000 * offset));
        cmp.set("v.clock", ("0" + time.getHours()).slice(-2)   + ":" + 
                ("0" + time.getMinutes()).slice(-2) + ":" + 
                ("0" + time.getSeconds()).slice(-2));
        var clientOffset = - time.getTimezoneOffset() / 60;
        cmp.set("v.currentOffset", - time.getTimezoneOffset() / 60);
        cmp.set("v.clientClock", ("0" + clientTime.getHours()).slice(-2)   + ":" + 
                ("0" + clientTime.getMinutes()).slice(-2) + ":" + 
                ("0" + clientTime.getSeconds()).slice(-2));
    },
    
    toggleDebugMode : function(cmp) {
        var debugMode = cmp.get("v.isDebugMode");
        cmp.set("v.isDebugMode", !debugMode);
    }
})