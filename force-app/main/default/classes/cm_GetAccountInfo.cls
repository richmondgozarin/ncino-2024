/*-----------------------------------------------------------------------------
DESCRIPTION	:	Text Collection Variable: Collection of account id in text format
AUTHOR		:	JA
VERSION		:	1.0
HISTORY		:
Date			Author				Comment
08-05-2023   John Alfonso Gamboa   Initial version
-----------------------------------------------------------------------------*/
public with sharing class cm_GetAccountInfo {

  /* This apex class is to be deleted and not already used
  @InvocableMethod(label='Get Account Information' description='Returns account records thru list of account ids') 
  public static List<output> getAccountList(List<getListId> param) {
    // System.debug(param);
    //List<String> ids = param[0].aId;
    // bypass id only
    List<String> ids = new List<String>();
    ids.add('0010C00000XGkt5QAD');

    List<Account> a = [Select Id, Name, PersonContactId, PersonEmail from Account where Id IN :ids]; //atabase.query('Select Id, Name from Account where Id IN :ids');
    //List<LLC_BI__AccountDocument__c> a = [Select Id, Name, LLC_BI__Has_File__c, LLC_BI__Account__r.PersonContactId, LLC_BI__Account__r.PersonEmail from LLC_BI__AccountDocument__c where LLC_BI__Account__c IN :ids];
    System.debug(a);
    output o = new output();
    o.records = a;
    return new List<output>{o};
  }
  
  public class getListId {
    @InvocableVariable(label='Text collection variable (Ids only)' required=true)
    public List<String> aId;
  }
  
  public class output {
    @InvocableVariable(label='Record Collection Variable')
    public List<Account> records;
  }
*/
}