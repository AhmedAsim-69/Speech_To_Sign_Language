import API

from importlib.machinery import SourceFileLoader

parent_module = SourceFileLoader('parent_module', 'API/Flask.py').load_module
parent_module.runnn