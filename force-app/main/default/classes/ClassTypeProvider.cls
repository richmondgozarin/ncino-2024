global virtual with sharing class ClassTypeProvider extends nFORCE.ClassTypeProvider{
   global override Type forName(String className) {
      return Type.forName(className);
   }
 
   global override Type forName(String packageName, String className) {
      return Type.forName(packageName, className);
   }
 
   global override String serialize(Object o) {
      return JSON.serialize(o);
   }
 
   global override Object deserialize(String jsonString, Type apexType) {
      return JSON.deserialize(jsonString,apexType);
   }
 
   global override Object newInstance(Type apexType) {
      return apexType.newInstance();
   }
}