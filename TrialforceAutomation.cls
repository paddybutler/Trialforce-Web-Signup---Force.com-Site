public without sharing class TrialforceAutomation{
    
    public String emailAddress {get;set;}
    public String firstName {get;set;}
    public String lastName {get;set;}
    public boolean disableSave {get;set;}
    
    public TrialforceAutomation(){
    
        disableSave = false;
    }
    
    public void createTrialOrg(){
    
        disableSave = true;
    
        CustomSiteSettings ds = getTrialSettings();
        ds.OrgNumber__c +=1;
        
        SignupRequest sr = new SignupRequest();
        sr.signupEmail = emailAddress;
        sr.username = emailAddress +'.Demo'+ Integer.valueOf(ds.OrgNumber__c);
        sr.country = 'GB';
        sr.company = 'Demo Org : '+ Integer.valueOf(ds.OrgNumber__c);
        sr.firstName = firstName;
        sr.lastName = lastName;
        sr.ShouldConnectToEnvHub = true;
        sr.templateId = ds.Current_Template_ID__c;

        try{
            insert sr;           
            upsert ds;
            
        }Catch(DMLException ex){
        
            System.debug('::: Error Creating Trial Org : '+ex);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Error Creating Demo Org - Please Try Again'));
            disableSave = false;
        }
        
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Creating Demo Org - Details will be emailed to you'));
    }
    


    private String getTemplateID(){
    
        CustomSiteSettings__c ds = CustomSiteSettings__c.getOrgDefaults();
        return ds.Current_Template_ID__c;
    }


    private CustomSiteSettingss__c getTrialSettings(){
    
        return CustomSiteSettings__c.getOrgDefaults();
        
    }



}
