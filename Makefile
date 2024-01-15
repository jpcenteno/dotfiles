.PHONY: switch
switch:
	nix run . -- switch --flake .#j
