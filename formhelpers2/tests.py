import unittest

from pyramid import testing

class ViewTests(unittest.TestCase):
    def setUp(self):
        self.config = testing.setUp()

    def tearDown(self):
        testing.tearDown()

    def test_my_view(self):
        from formhelpers2.views import comment
        request = testing.DummyRequest()
        info = comment(request)
        self.assertTrue(hasattr(info['forms'], 'comment_form'))
