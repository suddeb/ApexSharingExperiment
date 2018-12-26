public with sharing class MyWithSharingClass {
	public List<Car__c> fetchCars(){
		List<Car__c> allCars = new List<Car__c>();
		if(	Schema.sObjectType.Car__c.isAccessible() &&
				Schema.sObjectType.Car__c.Fields.Id.isAccessible()
			){
				allCars = [SELECT ID From Car__c];
		}return allCars;
	}
}
