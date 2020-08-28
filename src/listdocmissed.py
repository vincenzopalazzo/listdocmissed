#!/usr/bin/env python3
"""This is a small demo plugin
"""
from pyln.client import Plugin
import os
import sys
from pathlib import Path

plugin = Plugin()

command_ok_without_doc = [
    "doc",
]

@plugin.method("listdocmissed")
def list_doc_missed(plugin, path='/tmp/lightning/'):
    """
    This command listed all c-lightning rpc command without doc
    This help to maintain all command documented
    """

    help_result = plugin.rpc.help()['help']

    doc_dir = plugin.get_option('doc')
    path_os = Path(sys.executable)
    root_or_drive = path_os.root
    root_or_drive.join(path).join(doc_dir)
    path = os.path.join(root_or_drive, path, doc_dir)
    command_not_doc = []
    for command in help_result:
        command_name = command['command'].split()[0]
        if not is_documented(plugin, path, command_name) \
                and not (command['category'] == 'plugin') \
                and not (command_name in command_ok_without_doc) \
                and 'dev' not in command_name:
            command_not_doc.append(command_name)

    result = {'path-doc': path, 'commands': command_not_doc}
    return result


def is_documented(plugin, path, command):
    plugin.log(path)
    for file in os.listdir(path):
        if file.endswith(".md"):
            file_name = os.path.splitext(os.path.basename(file))[0]
            file_name = file_name.split(".")[0]
            if "-" not in file_name:
                continue
            file_name = file_name.split("-")[1]
            plugin.log('Final file name: {}'.format(file_name))
            plugin.log('Command: {}'.format(command))
            if command == file_name:
                return True
    return False


@plugin.init()
def init(options, configuration, plugin, **kwargs):
    plugin.log("Plugin helloworld.py initialized")


plugin.add_option('doc', 'doc', 'The greeting I should use.')

plugin.run()
