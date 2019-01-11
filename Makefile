minscript: minscript.d
	dmd minscript.d

install: minscript
	cp minscript ~/bin/minscript

clean:
	rm -rf minscript
