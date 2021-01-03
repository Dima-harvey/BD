function add_card(s,f) {
	var j;
	for (j = s; j <= f; j++) {
		db.read_card.insert([{_id: j,user_profile_id:j,book_id:j}]);
	}
}