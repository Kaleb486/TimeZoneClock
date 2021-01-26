public with sharing class TimeZoneClockController 
{
	@AuraEnabled(cacheable=true)
    public static String getTimeZone(String recordId)
    {
        System.debug('recordId: ' + recordId);
        TimeZone result = new TimeZone();
        if(recordId != null && recordId.length() > 0)
        {
            Id rId = recordId;
            String objectName = String.valueOf(rId.getSobjectType());
            List<Time_Zone_Clock_Configuration__mdt> configurations = [SELECT Label, SObject_Name__c, Field_Name__c 
                                                                       FROM Time_Zone_Clock_Configuration__mdt 
                                                                       WHERE SObject_Name__c = :objectName];
            if(configurations.size() == 0)
            {
                result.Message = 'This component is not configured to work with ' + objectName + '.';
            }
            else
            {
                String query = 'SELECT Id, ' +  configurations[0].Field_Name__c + ' FROM ' + objectName + ' WHERE Id = :recordId';
                SObject obj = Database.query(query).get(0);
                result.PhoneNumber = String.valueOf(obj.get(configurations[0].Field_Name__c));
                
                if(result.PhoneNumber != null && result.PhoneNumber.length() > 0)
                {
                    result.AreaCode = getAreaCode(result.PhoneNumber);
                    List<Area_Code__mdt> areaCodes = [SELECT Time_Zone__c FROM Area_Code__mdt WHERE Label = :result.AreaCode];
                    if(areaCodes.size() > 0)
                    {
                        result.TimeZones = areaCodes[0].Time_Zone__c.split('\\|');
                        for(Time_Zone__mdt tz : [SELECT Label, UTC_Offset__c FROM Time_Zone__mdt WHERE Label IN :result.TimeZones])
                        {
                            result.Offsets.add(tz.UTC_Offset__c);
                        }
                    }
                    else
                    {
                        result.Message = 'Cannot found corresponding time zone for area code (' + result.AreaCode +  ').';
                    }                    
                }
                else
                {
                    result.Message = 'No phone number can be used to resolve time zone.';
                }
            }
        }
        return JSON.serialize(result);
    }
    
    @TestVisible
    private static String getAreaCode(String phoneNumber)
    {
        String numericData = phoneNumber.replaceAll('[^0-9]', '');
		if(numericData.startsWith('1'))
        {
            return numericData.substring(1, 4);
        }
        return numericData.substring(0, 3);
    }
    
    public class TimeZone
    {
        public String Message {get; set;}
        public String AreaCode {get; set;}
        public String PhoneNumber {get; set;}
        public List<String> TimeZones {get; set;}
        public List<Decimal> Offsets {get; set;}
        
        public TimeZone()
        {
            TimeZones = new List<String>();
            Offsets = new List<Decimal>();
        }
    }
}