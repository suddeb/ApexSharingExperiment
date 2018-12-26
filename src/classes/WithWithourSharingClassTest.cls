@isTest
private class WithWithourSharingClassTest {

	static List<Car__c> fetchAllCars(){
		return [SELECT ID, Name From Car__c];
	}

	@isTest static void testCallingWithSharngFromWithoutSharing() {
		Car__c aCar;
		List<Car__c> fetchedCars = new List<Car__c>();
		List<User> allUsers = [SELECT ID FROM USER where Profile.Name = 'Standard Platform User' and IsActive = true LIMIT 2];

		//Insert a Car Record with User1 as the owner of the record
		System.runAs(allUsers.get(0)){
			aCar = new Car__c(Name = 'Honda City');
			insert aCar;

			fetchedCars = fetchAllCars();
			System.AssertEquals(1,fetchedCars.size());
			System.AssertEquals('Honda City',fetchedCars.get(0).Name);

		}
		System.runAs(allUsers.get(1)){
			System.AssertEquals(0,new MyWithoutSharingClass().fetchCars1().size());
			System.AssertEquals(1,new MyWithoutSharingClass().fetchCars2().size());
		}
	}

}
