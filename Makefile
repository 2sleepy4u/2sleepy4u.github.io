production:
	echo "OK"
	elm make ./src/Main.elm --output build/main.js --optimize
	brave ./index.html
