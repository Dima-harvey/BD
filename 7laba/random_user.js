function add(s, f) {
	var j;
	for (j = s; j <= f; j++) {
	   var passwords = '';

	   var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz';
	   var charactersLength = characters.length;
	   
	   for (var i = 0; i < 10; i++ ) {
		  passwords += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	   var value = Math.floor(Math.random()*3);
		db.user.insert([{_id: j, role_id: value,login: passwords,password:passwords}]);
	}
}
