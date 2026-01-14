.PHONY: test test-file

test:
	nvim --headless -u test/minimal_init.lua -c "PlenaryBustedDirectory test/ {minimal_init = 'test/minimal_init.lua', sequential = true}"

test-file:
	nvim --headless -u test/minimal_init.lua -c "PlenaryBustedFile $(FILE)"
