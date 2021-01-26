@isTest
private class TimeZoneClockController_Test 
{
    @isTest
    private static void getTimeZoneTest1() // positive test, no message is expected
    {
        Account acct = new Account(Name = 'Test Account', Phone = '416-555-1234');
        insert acct;
        String tz = TimeZoneClockController.getTimeZone(acct.Id);
        TimeZoneClockController.TimeZone result = (TimeZoneClockController.TimeZone)JSON.deserialize(tz, TimeZoneClockController.TimeZone.Class);
        System.assertEquals(null, result.Message);
    }

    @isTest
    private static void getTimeZoneTest2() // negative test, cannot find time zone for area code
    {
        Account acct = new Account(Name = 'Test Account', Phone = '1-555-555-1234');
        insert acct;
        String tz = TimeZoneClockController.getTimeZone(acct.Id);
        TimeZoneClockController.TimeZone result = (TimeZoneClockController.TimeZone)JSON.deserialize(tz, TimeZoneClockController.TimeZone.Class);
        System.assertEquals('Cannot found corresponding time zone for area code (555).', result.Message);
    }

    @isTest
    private static void getTimeZoneTest3() // negative test, not configured to work with opportunity
    {
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', StageName = 'Closed Won', CloseDate = Date.today());
        insert opp;
        String tz = TimeZoneClockController.getTimeZone(opp.Id);
        TimeZoneClockController.TimeZone result = (TimeZoneClockController.TimeZone)JSON.deserialize(tz, TimeZoneClockController.TimeZone.Class);
        System.assertEquals('This component is not configured to work with Opportunity.', result.Message);
    }

    @isTest
    private static void getTimeZoneTest4() // negative test, record's phone number is not specified
    {
        Account acct = new Account(Name = 'Test Account');
        insert acct;
        Contact cont = new Contact(LastName = 'Smith', AccountId = acct.Id);
        insert cont;
        String tz = TimeZoneClockController.getTimeZone(cont.Id);
        TimeZoneClockController.TimeZone result = (TimeZoneClockController.TimeZone)JSON.deserialize(tz, TimeZoneClockController.TimeZone.Class);
        System.assertEquals('No phone number can be used to resolve time zone.', result.Message);
    }

	@isTest
    private static void getAreaCodeTest()
    {
        System.assertEquals('416', TimeZoneClockController.getAreaCode('1-416-555-1234'));
        System.assertEquals('416', TimeZoneClockController.getAreaCode('(416)-555-1234'));
        System.assertEquals('416', TimeZoneClockController.getAreaCode('416-555-1234'));
        System.assertEquals('416', TimeZoneClockController.getAreaCode('4165551234'));
    }

    
}