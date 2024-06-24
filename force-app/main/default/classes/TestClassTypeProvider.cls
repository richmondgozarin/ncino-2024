@isTest(IsParallel=True)
public with sharing class TestClassTypeProvider {
  
    @isTest
    static void basic(){
        ClassTypeprovider provider = new ClassTypeprovider();

        Type classType = TestClassTypeProvider.class;
        String className = classType.getName();
        Account account1 = new Account(Name='TestClassTypeProviderTest1');

        System.assertEquals(classType, provider.forName(className));
        System.assertEquals(classType, provider.forName(nFORCE.Utility.getNamespacePrefix(className, ''), 'TestClassTypeProvider'));
        System.assertEquals(account1, provider.deserialize(provider.serialize(account1), Account.class));
        System.assert(provider.newInstance(classType) instanceof TestClassTypeProvider);
    }
}