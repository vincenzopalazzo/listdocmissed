from pyln.testing.fixtures import *
import logging
import os
import sys


logging.basicConfig(level=logging.DEBUG, stream=sys.stdout)
test_path = os.path.dirname(__file__)
plugin_path = os.path.join(test_path, '..', 'src', 'plugin.py')


def test_plugin_start(node_factory):
    """Simply try to start a node with the plugin.
    """
    l1 = node_factory.get_node(options={'plugin': plugin_path})
    print(l1.rpc.help())
    assert False

def test_plugin_rpc_call(node_factory):
    """Test the `hello` RPC method exposed by the plugin.
    """
    l1 = node_factory.get_node(options={'plugin': plugin_path})

    r = l1.rpc.listdocmissed('/tmp/lightning')
    assert('listtransactions' in r['commands'])