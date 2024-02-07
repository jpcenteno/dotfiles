.PHONY: switch
switch:
	nix run . -- switch --flake .#j

.PHONY: flake-checker
flake-checker:
	nix run "github:DeterminateSystems/flake-checker"
