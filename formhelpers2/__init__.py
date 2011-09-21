from pyramid.config import Configurator
from pyramid.session import UnencryptedCookieSessionFactoryConfig

def main(global_config, **settings):
    """
    This function returns a Pyramid WSGI application.
    """

    my_session_factory = UnencryptedCookieSessionFactoryConfig('formhelpers2')
    config = Configurator(settings=settings,
                          session_factory=my_session_factory)

    config.add_static_view('static', 'formhelpers2:static')

    config.scan()

    return config.make_wsgi_app()
