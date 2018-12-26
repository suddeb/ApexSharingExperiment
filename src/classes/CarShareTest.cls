@isTest
private class CarShareTest {
	static List<Car__c> fetchAllCars(){
		return [SELECT ID, Name From Car__c];
	}

	@isTest static void testCarManualShare() {
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

		//Trying to find the inserted car record with User2
		//Since OWD of car is private, inserted car record is not accessible to User2
		System.runAs(allUsers.get(1)){
			fetchedCars = fetchAllCars();
			System.AssertEquals(0,fetchedCars.size());
		}

		//Now sharing the inserted car record with User2
		System.runAs(allUsers.get(0)){
			CarShare.executeCarManualShare(aCar.Id,allUsers.get(1).Id);
		}

		//This time inserted car record is accessible to User2
		System.runAs(allUsers.get(1)){
			fetchedCars = fetchAllCars();
			System.AssertEquals(1,fetchedCars.size());
			System.AssertEquals('Honda City',fetchedCars.get(0).Name);
		}

		//Checking the Car Share table for the share record
		List<Car__Share> allCarShares = [SELECT ID, ParentId, AccessLevel, UserOrGroupId, RowCause FROM Car__Share];
		System.AssertEquals(1,allCarShares.size());
		System.AssertEquals(aCar.Id,allCarShares.get(0).ParentId);
		System.AssertEquals('Read',allCarShares.get(0).AccessLevel);
		System.AssertEquals(allUsers.get(1).Id,allCarShares.get(0).UserOrGroupId);
		System.AssertEquals(Schema.Car__Share.RowCause.Manual,allCarShares.get(0).RowCause);

		//Now changing the owner of the car record from User1 to User2
		System.runAs(allUsers.get(0)){
			aCar.OwnerId = allUsers.get(1).Id;
			update aCar;
		}

		//Since the owner has changed, record from car share table is also deleted.
		allCarShares = [SELECT ID, ParentId, AccessLevel, UserOrGroupId, RowCause FROM Car__Share];
		System.AssertEquals(0,allCarShares.size());

	}

	@isTest static void testCarProgrammaticShare() {
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

		}//Now sharing the inserted car record with User2
		System.runAs(allUsers.get(0)){
			CarShare.executeCarProgrammaticShare(aCar.Id,allUsers.get(1).Id);
		}

		//Now inserted car record is accessible to User2
		System.runAs(allUsers.get(1)){
			fetchedCars = fetchAllCars();
			System.AssertEquals(1,fetchedCars.size());
			System.AssertEquals('Honda City',fetchedCars.get(0).Name);
		}

		//Checking the Car Share table for the share record
		List<Car__Share> allCarShares = [SELECT ID, ParentId, AccessLevel, UserOrGroupId, RowCause FROM Car__Share];
		System.AssertEquals(1,allCarShares.size());
		System.AssertEquals(aCar.Id,allCarShares.get(0).ParentId);
		System.AssertEquals('Read',allCarShares.get(0).AccessLevel);
		System.AssertEquals(allUsers.get(1).Id,allCarShares.get(0).UserOrGroupId);
		System.AssertEquals(Schema.Car__Share.RowCause.ProgrammaticShare__c,allCarShares.get(0).RowCause);

		//Now changing the owner of the car record from User1 to User2
		System.runAs(allUsers.get(0)){
			aCar.OwnerId = allUsers.get(1).Id;
			update aCar;
		}

		//Now the owner has changed, but the record from car share table is not deleted because the rowcause is not manaul
		allCarShares = [SELECT ID, ParentId, AccessLevel, UserOrGroupId, RowCause FROM Car__Share];
		System.AssertEquals(1,allCarShares.size());
		System.AssertEquals(aCar.Id,allCarShares.get(0).ParentId);
		System.AssertEquals('Read',allCarShares.get(0).AccessLevel);
		System.AssertEquals(allUsers.get(1).Id,allCarShares.get(0).UserOrGroupId);
		System.AssertEquals(Schema.Car__Share.RowCause.ProgrammaticShare__c,allCarShares.get(0).RowCause);

	}

}