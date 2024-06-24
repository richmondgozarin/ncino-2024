public with sharing class ExceptionLogExample {
    public ExceptionLogExample() {

    }

    public static void dmlException() {
        try{
            Account acc = new Account(Name='Rich Business');
            update acc;
        }
        catch(DMLException ex){
            cm_ExceptionLog.log(ExceptionLogExample.class.getName(), 
                                'dmlException', 
                                ex);
        }
    }
    
    public static void listException() {
        try {
            List<Integer> li = new List<Integer>();
            li.add(15);
            // This list contains only one element,
            // but we're attempting to access the second element
            // from this zero-based list.
            Integer i1 = li[0]; 
            Integer i2 = li[1]; // Causes a ListException
        } catch(ListException ex) {
            cm_ExceptionLog.log(ExceptionLogExample.class.getName(), 
                                'listException', 
                                ex);
        }
    }
    
    public static void nullPointerException() {
        try {
            String s;
            Boolean b = s.contains('abc'); // Causes a NullPointerException
        } catch(NullPointerException npe) {
            System.debug('The following exception has occurred: ' + npe.getMessage());
            cm_ExceptionLog.log(ExceptionLogExample.class.getName(), 
                                'nullPointerException', 
                                npe);
        }
    }
    
    
    public static void queryException() {
        try {
            // this statement causes a QueryException because 
            // we're assiging the return value to a Account object
            // but no Account is returned.
            Account m = [SELECT Name FROM Account WHERE Name = 'XYZ' LIMIT 1];
        } catch(QueryException qe) {
            System.debug('The following exception has occurred: ' + qe.getMessage());    
            cm_ExceptionLog.log(ExceptionLogExample.class.getName(), 
                                'queryException', 
                                qe);
        }
    }
    
    public static void sobjectException() {
        try {
            Account acc = new Account(
                name='Rich Business 2023');
            insert acc;
        
            // Query the account we just inserted
            Account ac = [SELECT Name FROM Account WHERE Id = :acc.Id];
            // Causes an SObjectException because we didn't retrieve
            // the AccountNumber field.
            String s = ac.AccountNumber;
        } catch(SObjectException se) {
            System.debug('The following exception has occurred: ' + se.getMessage());
            cm_ExceptionLog.log(ExceptionLogExample.class.getName(), 
                                'sobjectException', 
                                se);
        }
    }
    
    public static void logMessage(String message) {
        cm_ExceptionLog.log(message == null ? 'Sample Log Messge' : message);
    }
    
    public static void genericException() {
        try {
            Account acc = new Account(
                name='Rich Business 2023');
            insert acc;
        
            // Query the account we just inserted
            Account ac = [SELECT Name FROM Account WHERE Id = :acc.Id];
            String s = ac.AccountNumber;
        } catch(Exception e) {
           System.debug('Exception type caught: ' + e.getTypeName()); 
           System.debug('Message: ' + e.getMessage()); 
           System.debug('Cause: ' + e.getCause()); // returns null
           System.debug('Line number: ' + e.getLineNumber()); 
           System.debug('Stack trace: ' + e.getStackTraceString()); 
        }
    }
}