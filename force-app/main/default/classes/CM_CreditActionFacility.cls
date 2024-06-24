/*-----------------------------------------------------------------------------
DESCRIPTION	:	
AUTHOR		:	Kuldeep
VERSION		:	1.0
Revision		:
Date			Author				Comment
18-04-2023		Kuldeep Parihar	    Initial version 
-----------------------------------------------------------------------------*/
public class CM_CreditActionFacility {
    public String actionType { get; set; } //'Modify' OR 'Renew'
	public String contextId { get; set; } //Loan Id
	public String modificationType { get; set;}   //'Collateral Modification
}