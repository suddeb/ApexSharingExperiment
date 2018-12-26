public without sharing class MyWithoutSharingClass {
	public List<Car__c> fetchCars1(){
		List<Car__c> allCars = new MyWithSharingClass().fetchCars();
		return allCars;
	}

	public List<Car__c> fetchCars2(){
		List<Car__c> allCars = new List<Car__c>();
		allCars = [SELECT ID From Car__c];
		return allCars;
	}
}
