function add_b(s,f) {
	var j;
	for (j = s; j <= f; j++) {
	   var n = '';
	   var a = '';
	   var g1 = '';
	   var g2 = '';

	   var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz';
	   var charactersLength = characters.length;
	   
	   for (var i = 0; i < 10; i++ ) {
		  a += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	   	
	for (var i = 0; i < 12; i++) {
		   n += characters.charAt(Math.floor(Math.random() * charactersLength));
	   } 	
	   
		for (var i = 0; i < 7; i++ ) {
		  g1 += characters.charAt(Math.floor(Math.random() * charactersLength));
		  g2 += characters.charAt(Math.floor(Math.random() * charactersLength));
	   }
	   var year = Math.floor(Math.random()*(2019-1965+1)) + 1965;
		var month = Math.floor(Math.random()*(12-1+1)) + 1;
		var day = Math.floor(Math.random()*(30-1+1)) + 1;
		
		if (month < 10)
			month = '0' + month;
		if (day < 10)
			day = '0' + day;
		
		DoB = year + '-' + month + '-' + day;
	   
		db.book.insert([{_id: j,author: a, name: n, genre:[g1, g2], publicationdate: ISODate(DoB)}]);
	}
}