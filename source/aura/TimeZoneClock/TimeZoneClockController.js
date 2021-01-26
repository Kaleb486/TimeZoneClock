({
	doInit : function  (cmp, event, helper) {
        var recordId = cmp.get("v.recordId");
        
        var action = cmp.get("c.getTimeZone");
        action.setParams({ "recordId" : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var timeZone = JSON.parse(response.getReturnValue());
                console.log(timeZone);
                if(!timeZone.Message)
                {
                	cmp.set("v.areaCode", timeZone.AreaCode);
                    cmp.set("v.timeZones", timeZone.TimeZones);
                    cmp.set("v.offsets", timeZone.Offsets);
                    setInterval(function() {helper.displayTime(cmp)}, 1000);
                }
                else
                {
                    cmp.set("v.message", timeZone.Message);
                }
            } 
        });
        $A.enqueueAction(action);
    },
    
    infoClick : function(cmp, event, helper) {
        helper.toggleDebugMode(cmp);
    }
})