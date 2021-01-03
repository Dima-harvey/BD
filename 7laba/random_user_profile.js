function add_profile(s, f) {
	var j;
	for (j = s; j <= f; j++) {
	   var fullname = '';
	   var surname = '';
	   var p = '';
	   var ph = 'D:\Study\SB\Photo.jpg';

	   var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz';
	   var num = '1234567890';
	   var charactersLength = characters.length;
	   var numLength = num.length;
	   
	   for (var i = 0; i < 10; i++ ) {
		  fullname += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	
	for (var i = 0; i < 15; i++) {
		   surname += characters.charAt(Math.floor(Math.random() * charactersLength));
	   } 
	   
	   for (var i = 0; i < 12; i++) {
			p += num.charAt(Math.floor(Math.random() * numLength));
	   }	
	   
		db.user.insert([{_id: j, user_id:j,Firstname:fullname,Surname:surname,phone:p,photo: ph}]);
	}
}
