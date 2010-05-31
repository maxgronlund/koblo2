function loadEvents()
{
	//Load the drop down function as the script loads
	//the syntax for calling drop down is dropDown(dropDownListBox, dropDownResultsBox, dropDownActionButton);
	//you can also pass additional callback function as the fourth parameter. This additional callback can process the action clicks for the list items.
	dropDown('deviceList', 'flexbox_results', 'flex_button');
	dropDown('flagList', 'flexbox_results1', 'flex_button1', extraCallback);
	dropDown('periodListOne', 'periodListOne_results', 'periodListOne_button');
	dropDown('periodListTwo', 'periodListTwo_results', 'periodListTwo_button');
}