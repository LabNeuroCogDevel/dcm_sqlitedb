all: db.sqlite3

clean:
	rm db.sqlite3

data/dicominfo.txt: 
	./mnt.bash
	./getHdr.bash

db.sqlite3: data/dicominfo.txt schema.sql
	./mkDB.bash

