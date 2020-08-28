# listdocmissed a plugin for c-lightning 

This plugin is made with the [lightningd/template](https://github.com/lightningd/template).

This plugin is developed to make a quickly and complete check of the documentation RPC command inside [c-lightning](https://github.com/ElementsProject/lightning).

## Who is this plugin for?

Everybody that want make a check if all RPC command have a documentation, so this plugin is not more util but have a big potentiality with the correct people :-) and maybe one of this people are you.

In fact, is possible exend this plugin to make a template of the documentation file and make easy the life of the core developer. Fell free to open a PR.

## Why I developer a PR

I developer this plugin because I fixed some documentation missed inside [c-lightning](https://github.com/ElementsProject/lightning), you can see the PR [here](https://github.com/ElementsProject/lightning/pull/3938).

## Run the plugin 

1. Install the plugin.

```bash
lightning-cli plugin start /home/vincent/Github/listdocmissed/src/plugin.py
```

2. Run plugin.

``` bash
lightning-cli listdocmissed /home/vincent/Github/lightning
```

## Other resources

[plugin-docs]: https://lightning.readthedocs.io/PLUGINS.html
[pyln-client-docs]: https://pyln-client.readthedocs.io/en/pyln/api.html
