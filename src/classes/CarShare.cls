public with sharing class CarShare {
	public static Boolean executeCarManualShare(Id carRecordId, Id userOrGroupId){
		Car__Share carShare = new Car__Share();
		carShare.ParentId	=	carRecordId;
		carShare.AccessLevel = 'Read';
		carShare.UserOrGroupId = userOrGroupId;
		carShare.RowCause = Schema.Car__Share.RowCause.Manual;
		Database.SaveResult sr = Database.insert(carShare, false);

		if(sr.isSuccess()){
			return true;
		}else{
			Database.Error err = sr.getErrors()[0];
			if(	err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
					err.getMessage().contains('AccessLevel')){
					return true;
			}else{
					return false;
			}
		}
	}

	public static Boolean executeCarProgrammaticShare(Id carRecordId, Id userOrGroupId){
		Car__Share carShare = new Car__Share();
		carShare.ParentId	=	carRecordId;
		carShare.AccessLevel = 'Read';
		carShare.UserOrGroupId = userOrGroupId;
		carShare.RowCause = Schema.Car__Share.RowCause.ProgrammaticShare__c;
		Database.SaveResult sr = Database.insert(carShare, false);

		if(sr.isSuccess()){
			return true;
		}else{
			Database.Error err = sr.getErrors()[0];
			if(	err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION &&
					err.getMessage().contains('AccessLevel')){
					return true;
			}else{
					return false;
			}
		}
	}
}