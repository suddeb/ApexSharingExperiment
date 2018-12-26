public with sharing class MyWithSharingClass {
	public List<Car__c> fetchCars(){
		List<Car__c> allCars = new List<Car__c>();
		allCars = [SELECT ID From Car__c];
		return allCars;
	}
}
