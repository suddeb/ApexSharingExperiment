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

	public with sharing class MyInnerClassWithSharing{
		public List<Car__c> fetchCars3(){
			List<Car__c> allCars = new List<Car__c>();
			allCars = [SELECT ID From Car__c];
			return allCars;
		}
	}

	public without sharing class MyInnerClassWithoutSharing{
		public List<Car__c> fetchCars4(){
			List<Car__c> allCars = new List<Car__c>();
			allCars = [SELECT ID From Car__c];
			return allCars;
		}
	}
}
